require 'active_support'

module Fields
  class DateFieldConfiguration < FieldConfiguration
    include Ejans::Fields::Filterable
    include Ejans::Fields::Sortable

    # Fields
    field :date_type, type: Symbol
    DATE_TYPES = [:year, :year_month, :year_month_day]
    validates :date_type, inclusion: { in: DATE_TYPES }

    field :filter_type, type: Symbol
    FILTER_TYPES = [:single, :range]
    validates :filter_type, inclusion: { in: FILTER_TYPES + [nil] }

    field :start_date_type, type: Symbol
    START_DATE_TYPES = [:start_now, :x_years_ago_start, :spesific_start_date]
    validates :start_date_type, inclusion: { in: START_DATE_TYPES }
    field :x_years_ago_start, type: Integer, default: 0
    field :spesific_start_date, type: Date

    field :end_date_type, type: Symbol
    END_DATE_TYPES = [:end_now, :x_years_ago_end, :x_years_later_end, :spesific_end_date]
    validates :end_date_type, inclusion: { in: END_DATE_TYPES }
    field :x_years_ago_end, type: Integer, default: 0
    field :x_years_later_end, type: Integer, default: 0
    field :spesific_end_date, type: Date

    # Callbacks
    before_validation :empty_fields
    validate :start_year_not_greater_than_end_year

    class << self
      def non_fields_for_date_types
        {
          start_now:            [:x_years_ago_start,  :spesific_start_date],
          x_years_ago_start:    [:spesific_start_date],
          spesific_start_date:  [:x_years_ago_start],
          end_now:              [:x_years_ago_end, :x_years_later_end, :spesific_end_date],
          x_years_ago_end:      [:x_years_later_end, :spesific_end_date],
          x_years_later_end:    [:x_years_ago_end, :spesific_end_date],
          spesific_end_date:    [:x_years_later_end, :x_years_ago_end]
        }
      end

      def internal_object(field)
        self.fields.select { |k,v| k == field.to_s }.first.last
      end

      def default_value(field)
        internal_object(field).default_val
      end
    end

    def now_year
      Time.now.utc.to_date.year
    end

    def to_year(x_year)
      x_year.to_i.years.ago.to_date.year
    end

    def start_year
      case start_date_type
      when :start_now
        now_year
      when :x_years_ago_start
        to_year(x_years_ago_start)
      when :spesific_start_date
        spesific_start_date.year
      end
    end

    def end_year
      case end_date_type
      when :end_now
        now_year
      when :x_years_ago_end
        to_year(x_years_ago_end)
      when :x_years_later_end
        to_year(-x_years_later_end)
      when :spesific_end_date
        spesific_end_date.year
      end
    end

    def filter_query(params = {})
      case filter_type
      when :single
        if params[machine_name].present?
          year = Integer(params[machine_name])
          start_date = Date.new.change(year: year)
          end_date = Date.new.change(year: year).end_of_year
          BlankCriteria.new.between(keyname => start_date..end_date)
        else
          BlankCriteria.new
        end
      when :range
        if params[start_machine_name].present? or params[end_machine_name].present?
          criteria = BlankCriteria.new
          criteria = criteria.gte(keyname => value_start(params)) if value_start(params)
          criteria = criteria.lte(keyname => value_end(params)) if value_end(params)
          criteria
        else
          BlankCriteria.new
        end
      end
    end

    def set_specifies
      node_klass.instance_eval <<-EOM
        include Mongoid::MultiParameterAttributes
        field :#{keyname}, type: Date

        validate :#{keyname}_presence_value
        validate :#{keyname}_start_date
        validate :#{keyname}_end_date
      EOM

      node_klass.class_eval <<-EOM
        def #{machine_name}
          #{keyname}
        end

        private

        def #{keyname}_presence_value
          if #{required?} and #{keyname}_not_defined?
            errors.add(:#{keyname}, "alani bos birakilamaz.")
          end
        end

        def #{keyname}_start_date
          if !#{keyname}_not_defined? && #{keyname}.year < #{start_year}
            errors.add(:#{keyname}, "baslangic tarihinden kucuk olamaz")
          end
        end

        def #{keyname}_end_date
          if !#{keyname}_not_defined? && #{keyname}.year > #{end_year}
            errors.add(:#{keyname}, "bitis tarihinden tarihinden buyuk olamaz")
          end
        end

        def #{keyname}_not_defined?
          #{keyname}.blank? or #{keyname} == Date.new(1) 
        end
      EOM
    end

    protected
    def empty_fields
      [start_date_type, end_date_type].each do |date_type|
        self.class.non_fields_for_date_types[date_type].each do |field|
          default_val = self.class.default_value(field)
          self.send("#{field}=", default_val)
        end
      end
    end

    private
    def start_machine_name
      "#{machine_name}_start"
    end

    def end_machine_name
      "#{machine_name}_end"
    end

    def value_start(params)
      if params[start_machine_name].present?
        val = Integer(params[start_machine_name])
        val < start_year ? nil : Date.new(val).beginning_of_year
      else
        nil
      end
    end

    def value_end(params)
      if params[end_machine_name].present?
        val = Integer(params[end_machine_name])
        val > end_year ? nil : Date.new(val).end_of_year
      else
        nil
      end
    end

    def start_year_not_greater_than_end_year
      if start_year > end_year
        errors.add(:base, "Start year, end year'den buyuk olamaz.")
      end
    end
  end
end
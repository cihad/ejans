module Features
  class DateFeatureConfiguration
    require 'active_support'
    include Mongoid::Document
    include Ejans::Features::FeatureConfigurationAbility
    include Ejans::Features::SingleValueFeatureConfiguration

    # Fields
    field :date_type, type: Symbol
    DATE_TYPES = [:year, :year_month, :year_month_day]

    field :filter_type, type: Symbol
    FILTER_TYPES = [:single, :range]

    field :start_date_type, type: Symbol
    START_DATE_TYPES = [:now, :x_years_ago, :spesific_start_date]
    field :x_years_ago, type: Integer
    field :spesific_start_date, type: Date

    field :end_date_type, type: Symbol
    END_DATE_TYPES = [:now_or_near, :spesific_end_date]
    field :now_or_near, type: Integer, default: 0
    field :spesific_end_date, type: Integer

    # Associations
    embedded_in :feature_view
    belongs_to :feature_configuration, class_name: "Features::FeatureConfiguration"

    # Callbacks
    before_validation :empty_fields

    class << self
      def non_fields_for_date_types
        {
          now:                [:x_year_ago, :spesific_start_date],
          spesific_end_date:  [:x_year_ago],
          x_years_ago:        [:spesific_start_date],
          now_or_near:        [:spesific_end_date],
          spesific_end_date:  [:now_or_near]
        }
      end

      def internal_object(field)
        self.fields.select { |k,v| k == field.to_s }.first.last
      end

      def default_value(field)
        internal_object(field).default_val
      end
    end

    # Object Methods
    def type
      "Date"
    end

    def filterable?
      true
    end

    def now_year
      Time.now.utc.to_date.year
    end

    def to_year(number)
      number.to_i.years.ago.to_date.year
    end

    def start_year
      case start_date_type
      when :now
        now_year
      when :x_years_ago
        to_year(x_years_ago)
      when :spesific_start_date
        spesific_start_date
      end
    end

    def end_year
      case end_date_type
      when :now_or_near
        to_year(now_or_near)
      when :spesific_end_date
        spesific_end_date
      end
    end

    def filter_query(params = {})
      case filter_type
      when :single
        if params["#{machine_name}"].present?
          year = Integer(params["#{machine_name}"])
          start_date = Date.new.change(year: year)
          end_date = Date.new.change(year: year).end_of_year
          NodeQuery.new.between(:"#{where}" => start_date..end_date).selector
        else
          {}
        end
      when :range
        if params["#{machine_name}_start"].present? or params["#{machine_name}_end"].present?
          start_year = params["#{machine_name}_start"].present? ? Integer(params["#{machine_name}_start"]) : start_year
          start_date = Date.new.change(year: start_year)

          end_year = params["#{machine_name}_end"].present? ? Integer(params["#{machine_name}_end"]) : end_year
          end_date = Date.new.change(year: end_year).end_of_year
          
          NodeQuery.new.between( :"#{where}" => start_date..end_date).selector
        else
          {}
        end
      end
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
  end
end
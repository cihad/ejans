module CustomFields
  module Fields
    module Date



      module ApplyCustomField
        def apply_date_custom_field(klass, rule)
          klass.field rule['keyname'].to_sym,
            as: rule['machine_name'].to_sym,
            type: ::Date
        end
      end



      module ApplyValidate
        def apply_date_validate(klass, rule)
          klass.send(:include, Mongoid::MultiParameterAttributes)

          if rule['required']
            klass.validates_presence_of rule['machine_name'].to_sym
          end

          if rule['cant_be_lower_than_start_year']
            klass.validate "rule['machine_name']_start_year".to_sym

            klass.class_eval <<-EOM, __FILE__, __LINE__ + 1
              private
              def #{rule['machine_name']}_start_year
                if #{rule['machine_name']}.year < #{rule['start_year']}
                  errors.add(:#{rule['machine_name']}, "baslangic tarihinden kucuk olamaz")
                end
              end
            EOM
          end

          if rule['cant_be_greater_than_end_year']
            klass.validate "rule['machine_name']_end_year".to_sym

            klass.class_eval <<-EOM, __FILE__, __LINE__ + 1
              private
              def #{rule['machine_name']}_end_year
                if #{rule['machine_name']}.year > #{rule['end_year']}
                  errors.add(:#{rule['machine_name']}, "bitis tarihinden tarihinden buyuk olamaz")
                end
              end
            EOM
          end
        end
      end



      module Query
        def date_criteria(params, rule)
          criteria = ::CustomFields::Criteria.new

          case rule['filter_type'].to_sym
          when :single
            year = params[rule['machine_name']].to_i
            start_date = Date.new.change(year: year).beginning_of_year
            end_date   = Date.new.change(year: year).end_of_year
            criteria.between( where_is_date(rule) => start_date..end_date)
          when :range
            if value_start(params)
              criteria = criteria.gte(
                where_is_date(rule) => 
                Date.new(params[date_start_machine_name(rule)].to_i).beginning_of_year)
            end

            if value_end(params)
              criteria = criteria.lte(
                where_is_date(rule) =>
                Date.new(params[date_end_machine_name(rule)].to_i).end_of_year)
            end
          end

          criteria
        end

        def date_param_exist?(params, rule)
          case rule['filter_type'].to_sym
          when :single
            params[rule['machine_name']].present?
          when :range
            params["#{rule['machine_name']}_start"].present? or
            params["#{rule['machine_name']}_end"].present?
          end
        end

        def where_is_date(rule)
          rule['keyname'].to_sym
        end

        ## custom methods
        def date_start_machine_name(rule)
          "#{rule['machine_name']}_start"
        end

        def date_end_machine_name(rule)
          "#{rule['machine_name']}_end"
        end
      end




      class Field < ::CustomFields::Fields::Default::Field
        include ::CustomFields::Filterable
        include ::CustomFields::Sortable
        extend ApplyCustomField
        extend ApplyValidate
        extend Query

        DATE_TYPES = [:year, :year_month, :year_month_day]
        FILTER_TYPES = [:single, :range]
        START_DATE_TYPES = [:start_now, :x_years_ago_start, :spesific_start_date]
        END_DATE_TYPES = [:end_now, :x_years_ago_end, :x_years_later_end, :spesific_end_date]
        
        ## fields
        field :date_type,           type: ::Symbol
        field :filter_type,         type: ::Symbol

        field :start_date_type,     type: ::Symbol
        field :x_years_ago_start,   type: ::Integer, default: 0
        field :spesific_start_date, type: ::Date

        field :end_date_type,       type: ::Symbol
        field :x_years_ago_end,     type: ::Integer, default: 0
        field :x_years_later_end,   type: ::Integer, default: 0
        field :spesific_end_date,   type: ::Date

        ## validates
        validates :date_type, inclusion: { in: DATE_TYPES }
        validates :filter_type, inclusion: { in: FILTER_TYPES + [nil] }
        validates :start_date_type, inclusion: { in: START_DATE_TYPES }
        validates :end_date_type, inclusion: { in: END_DATE_TYPES }
        validate :start_year_not_greater_than_end_year


        def self.non_fields_for_date_types
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

        def self.now_year
          Time.now.utc.to_date.year
        end

        def self.to_year(x_year)
          x_year.to_i.years.ago.to_date.year
        end

        def start_year
          case start_date_type
          when :start_now           then self.class.now_year
          when :x_years_ago_start   then self.class.to_year(x_years_ago_start)
          when :spesific_start_date then spesific_start_date.year
          end
        end

        def end_year
          case end_date_type
          when :end_now           then self.class.now_year
          when :x_years_ago_end   then self.class.to_year(x_years_ago_end)
          when :x_years_later_end then self.class.to_year(-x_years_later_end)
          when :spesific_end_date then spesific_end_date.year
          end
        end

        def custom_recipe
          { 'date_type'           => date_type,
            'filter_type'         => filter_type,
            'start_date_type'     => start_date_type,
            'x_years_ago_start'   => x_years_ago_start,
            'spesific_start_date' => (spesific_start_date || nil),
            'end_date_type'       => end_date_type,
            'x_years_ago_end'     => x_years_ago_end,
            'x_years_later_end'   => x_years_later_end,
            'spesific_end_date'   => spesific_end_date }
        end

        def fill_node_with_random_value(node)
          node.send("#{machine_name}=", ::Date.new(::Random.rand(start_year...end_year)))
        end

        private
        def start_year_not_greater_than_end_year
          if start_year > end_year
            errors.add(:base, "Start year, end year'den buyuk olamaz.")
          end
        end
      end




    end
  end
end
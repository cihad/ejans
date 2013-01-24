module CustomFields
  module Fields
    module Date



      module ApplyCustomField
        def apply_date_custom_field(klass, rule)
          klass.field rule['keyname'].to_sym,
            as: rule['machine_name'].to_sym,
            type: ::Date

          klass.class_eval do
            define_method rule['machine_name'] do
              Presenter.new(self[rule['keyname']], rule)
            end
          end
        end
      end



      module ApplyValidate
        def apply_date_validate(klass, rule)
          klass.send(:include, Mongoid::MultiParameterAttributes)

          if rule['required']
            klass.validates_presence_of rule['keyname'].to_sym
          end

          if rule['cant_be_lower_than_start_year']
            klass.validate "rule['keyname']_start_year".to_sym

            klass.class_eval <<-EOM, __FILE__, __LINE__ + 1
              private
              def #{rule['keyname']}_start_year
                if #{rule['keyname']}.year < #{rule['start_year']}
                  errors.add(:#{rule['keyname']}, "baslangic tarihinden kucuk olamaz")
                end
              end
            EOM
          end

          if rule['cant_be_greater_than_end_year']
            klass.validate "rule['keyname']_end_year".to_sym

            klass.class_eval <<-EOM, __FILE__, __LINE__ + 1
              private
              def #{rule['keyname']}_end_year
                if #{rule['keyname']}.year > #{rule['end_year']}
                  errors.add(:#{rule['keyname']}, "bitis tarihinden tarihinden buyuk olamaz")
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
            if value(params, rule)
              criteria = criteria.between( where_is_date(rule) => value(params, rule))
            end
          when :range
            if start_value(params, rule)
              criteria = criteria.gte(where_is_date(rule) => start_value(params, rule))
            end

            if end_value(params, rule)
              criteria = criteria.lte(where_is_date(rule) => end_value(params, rule))
            end
          end

          criteria
        end

        def date_param_exist?(params, rule)
          case rule['filter_type'].to_sym
          when :single
            params[date_machine_name(rule)].present?
          when :range
            params[date_start_machine_name(rule)].present? or
            params[date_end_machine_name(rule)].present?
          end
        end

        def where_is_date(rule)
          rule['keyname'].to_sym
        end

        ## custom methods
        def value(params, rule)
          date = ::Date.new.change(year: Integer(params[date_machine_name(rule)])) rescue return
          date.beginning_of_year..date.end_of_year
        end

        def start_value(params, rule)
          ::Date.new(Integer(params[date_start_machine_name(rule)])).beginning_of_year rescue nil
        end

        def end_value(params, rule)
          ::Date.new(Integer(params[date_end_machine_name(rule)])).end_of_year rescue nil
        end

        def date_machine_name(rule)
          rule['machine_name'].to_s
        end

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
        START_DATE_TYPES = [:start_now, :x_years_ago_start, :specific_start_date]
        END_DATE_TYPES = [:end_now, :x_years_ago_end, :x_years_later_end, :specific_end_date]
        
        ## fields
        field :date_type,           type: ::Symbol
        field :filter_type,         type: ::Symbol

        field :start_date_type,     type: ::Symbol
        field :x_years_ago_start,   type: ::Integer, default: 0
        field :specific_start_date, type: ::Date

        field :end_date_type,       type: ::Symbol
        field :x_years_ago_end,     type: ::Integer, default: 0
        field :x_years_later_end,   type: ::Integer, default: 0
        field :specific_end_date,   type: ::Date

        ## validates
        validates_presence_of :date_type, :start_date_type, :end_date_type
        validates :date_type, inclusion: { in: DATE_TYPES }
        validates :filter_type, inclusion: { in: FILTER_TYPES + [nil] }
        validates :start_date_type, inclusion: { in: START_DATE_TYPES }
        validates :end_date_type, inclusion: { in: END_DATE_TYPES }
        validate :start_year_not_greater_than_end_year


        def self.non_fields_for_date_types
          {
            start_now:            [:x_years_ago_start,  :specific_start_date],
            x_years_ago_start:    [:specific_start_date],
            specific_start_date:  [:x_years_ago_start],
            end_now:              [:x_years_ago_end, :x_years_later_end, :specific_end_date],
            x_years_ago_end:      [:x_years_later_end, :specific_end_date],
            x_years_later_end:    [:x_years_ago_end, :specific_end_date],
            specific_end_date:    [:x_years_later_end, :x_years_ago_end]
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
          when :specific_start_date then specific_start_date.year
          end
        end

        def end_year
          case end_date_type
          when :end_now           then self.class.now_year
          when :x_years_ago_end   then self.class.to_year(x_years_ago_end)
          when :x_years_later_end then self.class.to_year(-x_years_later_end)
          when :specific_end_date then specific_end_date.year
          end
        end

        def custom_recipe
          { 'date_type'           => date_type,
            'filter_type'         => filter_type,
            'start_date_type'     => start_date_type,
            'x_years_ago_start'   => x_years_ago_start,
            'specific_start_date' => (specific_start_date || nil),
            'end_date_type'       => end_date_type,
            'x_years_ago_end'     => x_years_ago_end,
            'x_years_later_end'   => x_years_later_end,
            'specific_end_date'   => specific_end_date }
        end

        def fill_node_with_random_value(node)
          node.send("#{keyname}=", ::Date.new(::Random.rand(start_year...end_year)))
        end

        private
        def start_year_not_greater_than_end_year
          if start_year > end_year
            errors.add(:base, "Start year, end year'den buyuk olamaz.")
          end
        end
      end



      class Presenter < ::CustomFields::Fields::Default::Presenter

        def to_s
          case metadata['date_type']
          when :year then source.year
          when :year_month then [source.month, source.year]
          when :year_month_day then source
          end
        end
        alias :value :to_s

      end




    end
  end
end
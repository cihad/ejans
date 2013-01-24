module CustomFields
  module Fields
    module Integer



      module ApplyCustomField
        def apply_integer_custom_field(klass, rule)
          klass.field rule['keyname'].to_sym,
            as: rule['machine_name'].to_sym,
            type: ::Integer
        end
      end



      module ApplyValidate
        def apply_integer_validate(klass, rule)
          if rule['required']
            klass.validates_presence_of rule['keyname'].to_sym
          end

          if rule['min']
            klass.validates_numericality_of rule['keyname'].to_sym,
              greater_than_or_equal_to: rule['min']
          end

          if rule['max']
            klass.validates_numericality_of rule['keyname'].to_sym,
              less_than_or_equal_to: rule['max']
          end
        end
      end



      module Query
        def integer_criteria(params, rule)
          criteria = ::CustomFields::Criteria.new

          case rule['filter_type'].to_sym
          when :single
            if value(params, rule)
              criteria = criteria.where(where_is_integer(rule) => value(params, rule))
            end
          when :range
            if min_value(params, rule)
              criteria = criteria.gte(where_is_integer(rule) => min_value(params, rule))
            end

            if max_value(params, rule)
              criteria = criteria.lte(where_is_integer(rule) => max_value(params, rule))
            end
          end

          criteria
        end

        def integer_param_exist?(params, rule)
          case rule['filter_type'].to_sym
          when :single
            params[machine_name(rule)].present?
          when :range
            params[min_machine_name(rule)].present? or
            params[max_machine_name(rule)].present?
          end
        end

        def where_is_integer(rule)
          rule['keyname'].to_sym
        end

        ## custom methods
        def value(params, rule)
          Integer(params[machine_name(rule)]) rescue nil
        end

        def min_value(params, rule)
          Integer(params[min_machine_name(rule)]) rescue nil
        end

        def max_value(params, rule)
          Integer(params[max_machine_name(rule)]) rescue nil
        end

        def machine_name(rule)
          rule['machine_name'].to_s
        end

        def min_machine_name(rule)
          "#{rule['machine_name']}_min"
        end

        def max_machine_name(rule)
          "#{rule['machine_name']}_max"
        end
      end



      class Field < ::CustomFields::Fields::Default::Field
        include ::CustomFields::Filterable
        include ::CustomFields::Sortable
        extend ApplyCustomField
        extend ApplyValidate
        extend Query


        FILTER_TYPES = [:single, :range]
        THOUSAND_MARKERS = [:none, :decimal_point, :comma, :space]

        ## fields
        field :filter_type,     type: ::Symbol
        field :minimum,         type: ::Integer, default: 0
        field :maximum,         type: ::Integer
        field :prefix
        field :suffix
        field :thousand_marker, type: ::Symbol

        ## validates
        validates :filter_type, inclusion: { in: FILTER_TYPES + [nil] }
        validates :thousand_marker, inclusion: { in: THOUSAND_MARKERS }
        validate :min_can_not_greater_than_max

        def delimiter
          case thousand_marker
          when :decimal_point then "."
          when :comma         then ","
          when :space         then " "
          else ""
          end
        end


        def fill_node_with_random_value(node)
          minimum = minimum || 0
          maximum = maximum || 1000
          val     = Random.rand(0..1000)
          node.send("#{keyname}=", val)
        end

        def custom_recipe
          { 'filter_type' => filter_type,
            'minimum'     => minimum,
            'maximum'     => maximum,
            'prefix'      => prefix,
            'suffix'      => suffix,
            'delimiter'   => delimiter }
        end

        private
        def min_can_not_greater_than_max
          if minimum and maximum and maximum <= minimum
            errors.add(:base, "Minumum, maksimuma esit ve maksimumdan buyuk olamaz.")
          end
        end
      end





    end
  end
end
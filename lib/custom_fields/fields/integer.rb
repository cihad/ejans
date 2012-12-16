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
            klass.validates_presence_of rule['machine_name'].to_sym
          end

          if rule['min']
            klass.validates_numericality_of rule['machine_name'].to_sym,
              greater_than_or_equal_to: rule['min']
          end

          if rule['max']
            klass.validates_numericality_of rule['machine_name'].to_sym,
              less_than_or_equal_to: rule['max']
          end
        end
      end



      module Query
        def integer_criteria(params, rule)
          criteria = ::CustomFields::Criteria.new

          case rule['filter_type'].to_sym
          when :single
            criteria.where(where_is_integer(rule) => value)
          when :range
            criteria.between(
              where_is_integer(rule) =>
                params[integer_min_machine_name(rule)]..params[integer_max_machine_name(rule)]
            )
          end

          criteria
        end

        def integer_param_exist?(params, rule)
          case rule['filter_type'].to_sym
          when :single
            params[rule['machine_name']].present?
          when :range
            params[integer_min_machine_name(rule)].present? or
            params[integer_max_machine_name(rule)].present?
          end
        end

        def where_is_integer(rule)
          rule['keyname'].to_sym
        end

        ## custom methods
        def integer_min_machine_name(rule)
          "#{rule['machine_name']}_min"
        end

        def integer_max_machine_name(rule)
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
          node.send("#{machine_name}=", val)
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
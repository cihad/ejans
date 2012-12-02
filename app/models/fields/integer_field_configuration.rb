module Fields
  class IntegerFieldConfiguration < FieldConfiguration
    include Ejans::Fields::Filterable
    include Ejans::Fields::Sortable

    FILTER_TYPES = [:number_field, :range_with_number_field]
    THOUSAND_MARKERS = [:none, :decimal_point, :comma, :space]

    field :filter_type, type: Symbol
    field :minimum, type: Integer, default: 0
    field :maximum, type: Integer
    field :prefix, type: String
    field :suffix, type: String
    field :thousand_marker, type: Symbol

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

    def set_specifies
      node_klass.instance_eval <<-EOM
        field :#{keyname}, as: :#{machine_name}, type: Integer

        validate :#{keyname}_presence_value
        validate :#{keyname}_not_greater_than_maximum
        validate :#{keyname}_not_less_than_minimum
      EOM

      node_klass.class_eval <<-EOM        
        private
        def #{keyname}_presence_value
          if #{required?} and #{keyname}.blank?
            errors.add(:#{keyname}, "bos birakilamaz.")
          end
        end

        def #{keyname}_not_greater_than_maximum
          if #{keyname}.present? and #{maximum || false} and #{keyname} > #{maximum}
            errors.add(:#{keyname}, "#{maximum} degerinden fazla olamaz.")
          end
        end

        def #{keyname}_not_less_than_minimum
          if #{keyname}.present? and #{minimum || false} and #{keyname} < #{minimum}
            errors.add(:#{keyname}, "#{minimum} degerinden az olamaz.")
          end
        end
      EOM
    end

    def filter_query(params = {})
      case filter_type
      when :number_field
        if params[machine_name].present?
          value = Integer(params[machine_name])
          BlankCriteria.new.where(keyname => value)
        else
          BlankCriteria.new
        end
      when :range_with_number_field
        if params[min_machine_name].present? or params[max_machine_name].present?
          criteria = BlankCriteria.new
          criteria = criteria.gte(keyname => value_min(params)) if value_min(params)
          criteria = criteria.lte(keyname => value_max(params)) if value_max(params)
          criteria
        else
          BlankCriteria.new
        end
      end
    end

    def min_machine_name
      "#{machine_name}_min"
    end

    def max_machine_name
      "#{machine_name}_max"
    end

    def fill_node_with_random_value(node)
      minimum = minimum || 0
      maximum = maximum || 1000
      val     = Random.rand(0..1000)
      node.send("#{machine_name}=", val)
    end

    private
    def value_min(params)
      if params[min_machine_name].present?
        val = Integer(params[min_machine_name])
        (minimum.present? and val < minimum) ? nil : val
      else
        nil
      end
    end

    def value_max(params)
      if params[max_machine_name].present?
        val = Integer(params[max_machine_name])
        (maximum.present? and val > maximum) ? nil : val
      else
        nil
      end
    end

    def min_can_not_greater_than_max
      if minimum and maximum and maximum <= minimum
        errors.add(:base, "Minumum, maksimuma esit ve maksimumdan buyuk olamaz.")
      end
    end
  end
end
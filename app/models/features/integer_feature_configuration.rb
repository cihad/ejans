module Features
  class IntegerFeatureConfiguration < FeatureConfiguration
    include Mongoid::Document
    include Ejans::Features::Filterable
    include Ejans::Features::Sortable

    field :filter_type, type: Symbol
    FILTER_TYPES = [:number_field, :range_with_number_field]
    validates :filter_type, inclusion: { in: FILTER_TYPES + [nil] }

    field :minimum, type: Integer, default: 0
    field :maximum, type: Integer
    field :prefix, type: String
    field :suffix, type: String
    field :thousand_marker, type: Symbol
    THOUSAND_MARKERS = [:none, :decimal_point, :comma, :space]
    validates :thousand_marker, inclusion: { in: THOUSAND_MARKERS }

    def data_names
      super + [:"#{machine_name}_value"]
    end

    def data_for_node
      super.merge({
        :"#{machine_name}_min" => minimum,
        :"#{machine_name}_max" => maximum,
        :"#{machine_name}_prefix" => prefix,
        :"#{machine_name}_suffix" => suffix,
        :"#{machine_name}_delimiter" => delimiter, })
    end

    def delimiter
      case thousand_marker
      when :none
        ""
      when :decimal_point
        "."
      when :comma
        ","
      when :space
        " "
      else
        ""
      end
    end

    def filter_query(params = {})
      case filter_type
      when :number_field
        if params[machine_name].present?
          value = Integer(params[machine_name])
          NodeQuery.new.where(:"#{where}" => value)
        else
          NodeQuery.new
        end
      when :range_with_number_field
        if params[min_machine_name].present? or params[max_machine_name].present?
          query = NodeQuery.new
          query = query.gte(:"#{where}" => value_min(params)) if value_min(params)
          query = query.lte(:"#{where}" => value_max(params)) if value_max(params)
          query
        else
          NodeQuery.new
        end
      end
    end

    def min_machine_name
      "#{machine_name}_min"
    end

    def max_machine_name
      "#{machine_name}_max"
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
  end
end
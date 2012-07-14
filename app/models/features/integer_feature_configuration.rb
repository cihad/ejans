module Features
  class IntegerFeatureConfiguration
    include Mongoid::Document
    include Ejans::Features::FeatureConfigurationAbility

    # Fields
    FILTER_TYPES = [:number_field, :range_with_number_field]
    field :filter_type, type: Symbol

    field :minumum, type: Integer
    field :maximum, type: Integer
    field :prefix, type: String
    field :suffix, type: String
    field :thousand_marker, type: Symbol
    THOUSAND_MARKERS = [:none, :decimal_point, :comma, :space]

    # Validatations
    validates :filter_type, inclusion: { in: FILTER_TYPES }

    # Associations
    embedded_in :feature_configuration, class_name: "Features::FeatureConfiguration"


    def build_assoc!(node)
      if node.features.map(&:feature_configuration).include?(parent)
        feature = node.features.where(feature_configuration_id: parent.id.to_s).first
      else
        feature = node.features.build
        feature.feature_configuration = parent
        feature.send("build_#{feature_type}")
      end

      feature.child.class.add_value(value_name)
    end

    def type
      "Integer"
    end

    def filterable?
      true
    end

    def filter_query(params = {})
      case filter_type
      when :number_field
        if params[machine_name].present?
          value = Integer(params[machine_name])
          NodeQuery.new.where(:"#{where}" => value).selector
        else
          {}
        end
      when :range_with_number_field
        if params[min_machine_name].present? or params[max_machine_name].present?
          query = NodeQuery.new
          query = query.gte(:"#{where}" => value_min(params)) if value_min(params)
          query = query.lte(:"#{where}" => value_max(params)) if value_max(params)
          query.selector
        else
          {}
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
        val < minumum ? nil : val
      else
        nil
      end
    end

    def value_max(params)
      if params[max_machine_name].present?
        val = Integer(params[max_machine_name])
        val > maximum ? nil : val
      else
        nil
      end
    end
  end
end
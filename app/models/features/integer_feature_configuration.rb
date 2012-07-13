module Features
  class IntegerFeatureConfiguration
    include Mongoid::Document
    include Ejans::Features::FeatureConfigurationAbility
    include Ejans::Features::SingleValueFeatureConfiguration

    # Fields
    FILTER_TYPES = [:number_field, :range_with_number_field, :range_with_slider]
    field :filter_type, type: Symbol

    field :minumum, type: Integer
    field :maximum, type: Integer
    field :prefix, type: String
    field :suffix, type: String
    field :thousand_marker, type: Symbol
    THOUSAND_MARKERS = [:none, :decimal_point, :comma, :space]


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

    def filter_query(params = ActiveSupport::HashWithIndifferentAccess.new)
      case filter_type
      when :number_field
        if params["#{machine_name}"].present?
          value = Integer(params["#{machine_name}"])
          NodeQuery.new.where(:"#{where}" => value).selector
        else
          {}
        end
      when :range_with_number_field, :range_with_slider
        if params["#{machine_name}_min"].present? or params["#{machine_name}_max"].present?
          value_min = params["#{machine_name}_min"].present? ? Integer(params["#{machine_name}_min"]) : minumum
          value_max = params["#{machine_name}_max"].present? ? Integer(params["#{machine_name}_max"]) : maximum
          NodeQuery.new.between( :"#{where}" => value_min..value_max).selector
        else
          {}
        end
      end
    end
  end
end
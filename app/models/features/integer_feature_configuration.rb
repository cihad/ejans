module Features
  class IntegerFeatureConfiguration
    include Mongoid::Document
    field :minumum, type: Integer
    field :maximum, type: Integer
    field :filter_type, type: Symbol
    embedded_in :feature_configuration, class_name: "Features::FeatureConfiguration"

    FILTER_TYPES = [:number_field, :range_with_number_field, :range_with_slider]

    def type
      "Integer"
    end

    def machine_name
      feature_configuration.machine_name
    end

    def filter_query(params = {})
      where = "features."
      where += "#{feature_configuration.feature_type}."
      where += "#{feature_configuration.value_name}"
      case filter_type
      when :number_field
        if params["#{machine_name}"].present?
          value = params["#{machine_name}"].to_i
          [{ :"#{where}" => value }]
        else
          [{}]
        end
      when :range_with_number_field, :range_with_slider
        if params["#{machine_name}_min"].present? or params["#{machine_name}_max"].present?
          value_min = params["#{machine_name}_min"].present? ? params["#{machine_name}_min"].to_i : minumum
          value_max = params["#{machine_name}_max"].present? ? params["#{machine_name}_max"].to_i : maximum
          [{ :"#{where}".gte => value_min }, 
           { :"#{where}".lte => value_max }]
        else
          [{}]
        end
      end
    end
  end
end
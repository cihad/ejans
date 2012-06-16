module FeatureForms
  class ListFeatureForm < FeatureForm
    def value
      :"#{feature_configuration.value_name}_ids"
    end

    def list_item_ids_name
      :"#{value_name.singularize}_ids"
    end
  end
end
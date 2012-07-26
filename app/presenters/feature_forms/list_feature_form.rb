module FeatureForms
  class ListFeatureForm < FeatureForm
    def form_key
      :"#{key_name}_ids"
    end

    def list_item_ids_name
      :"#{key_name.singularize}_ids"
    end
  end
end
module FeatureForms
  class PlaceFeatureForm < FeatureForm
    def value
      :"#{feature_configuration.value_name}_ids"
    end

    def level
      child.level
    end

    def top_place
      child.top_place
    end

    def tree
      top_place.send("tree#{level}")
    end

    def place_ids_name
      :"#{value_name.singularize}_ids"
    end
  end
end
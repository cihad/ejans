module FeatureForms
  class PlaceFeatureForm < FeatureForm
    def value
      :"#{key_name}_ids"
    end

    def level
      conf.level
    end

    def top_place
      conf.top_place
    end

    def tree
      levels = top_place.levels
      levels.shift
      levels.first(level)
    end

    def place_ids_name
      :"#{key_name.to_s.singularize}_ids"
    end
  end
end
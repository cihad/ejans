module FormFields
  class PlaceFormField < FormField
    def value
      :"#{keyname}_ids"
    end

    def level
      conf.level
    end

    def top_place
      conf.top_place
    end

    def form_level_names
      conf.form_level_names
    end

    def tree
      levels = top_place.levels
      levels.shift
      levels.first(level)
    end

    def place_ids_name
      :"#{keyname.to_s.singularize}_ids"
    end
  end
end
module FeatureFilters
  class PlaceFeatureFilter < Filter

    def level_machine_names
      child.level_machine_names
    end

    def form_level_names
      child.form_level_names
    end

    def form_machine_names
      child.form_machine_names
    end

    def level
      child.level
    end

    def tree
      child.top_place.send("tree#{level}")
    end
  end
end
module FeatureFilters
  class PlaceFeatureFilter < Filter
    def level_machine_names
      conf.level_machine_names
    end

    def form_level_names
      conf.form_level_names
    end

    def form_machine_names
      conf.form_machine_names
    end

    def level
      conf.level
    end

    def tree
      levels = conf.top_place.levels
      levels.shift
      levels.first(level)
    end
  end
end
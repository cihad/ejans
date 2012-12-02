module FieldFilters
  class PlaceFieldFilter < Filter
    def form_machine_names
      level.times.map { |i| "#{machine_name}_#{i}"  }
    end

    def level
      @level ||= conf.level
    end

    def tree
      levels = conf.top_place.levels
      levels.shift
      levels.first(level)
    end
  end
end
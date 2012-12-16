module FieldFilters
  class PlaceFieldFilter < Filter
    def form_machine_names
      level.times.map { |i| "#{machine_name}_#{i}"  }
    end

    def level
      @level ||= field.level
    end

    def tree
      field.top_place.levels_unless_self.first(level)
    end
  end
end
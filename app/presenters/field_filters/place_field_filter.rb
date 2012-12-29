module FieldFilters
  class PlaceFieldFilter < Filter

    delegate :level, :top_place, to: :field


    def form_machine_names
      level.times.map { |i| "#{machine_name}_#{i}"  }
    end

    def tree
      top_place.levels_unless_self.first(level)
    end
  end
end
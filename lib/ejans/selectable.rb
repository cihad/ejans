module Ejans
  module Selectable
    # return { filter_id => selections_array }
    def selections_map
      h = Hash.new { |hash, key| hash[key] = [] }
      selections.inject(h) do |hash, selection| 
        hash[selection.filter_id] << selection.id; hash
      end
    end

    def matching?(object)
      sm = object.selections_map
      self.selections_map.inject([]) do |a, filter_selection|
        filter_id, selection_ids = filter_selection
        a << (selection_ids & sm[filter_id]).present?
      end.all?
    end
  end

  module SelectingMap
    # return { filter_id => selections_array }
    def self.map_by_selections(selections)
      h = Hash.new { |hash, key| hash[key] = [] }
      selections.inject(h) { |hash, selection| hash[selection.filter.id] << selection.id; hash }
    end
    
  end
end
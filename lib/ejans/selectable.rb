module Ejans
  module Selectable
    def selections_map
      h = Hash.new { |hash, key| hash[key] = [] }
      selections.includes(:filter).inject(h) do |hash, selection| 
        hash[selection.filter.id] << selection.id; hash
      end
    end

    def self.selections_map_by_selection_ids(*selections)
      h = Hash.new { |hash, key| hash[key] = [] }
      selections = Selection.find(selections).includes(:filter)
      selections.inject(h) { |hash, selection| hash[selection.filter.id] << selection.id; hash }
    end
  end
end
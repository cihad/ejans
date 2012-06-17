module FeatureFilters
  class ListFeatureFilter < Filter
    def list_items
      child.list_items
    end
  end
end
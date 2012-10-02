module FieldFilters
  class BelongsToFieldFilter < Filter
    def parent_node_node_type
      conf.parent_node_node_type
    end
  end
end
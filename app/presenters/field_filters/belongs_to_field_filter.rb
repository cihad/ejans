module FieldFilters
  class BelongsToFieldFilter < Filter

    delegate :parent_node_node_type, to: :field
    
  end
end
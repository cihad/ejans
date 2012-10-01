module FieldFilters
  class BelongsToFieldFilter < Filter
    def belongs_to_node_type
      conf.belongs_to_node_type
    end
  end
end
module FormFields
  class BelongsToFormField < FormField
    def form_key
      :"#{super}_id"
    end

    def belongs_to_node_type
      conf.belongs_to_node_type
    end

    def nodes
      belongs_to_node_type.nodes
    end
  end
end
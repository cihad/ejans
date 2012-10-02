module FormFields
  class BelongsToFormField < FormField
    def form_key
      :"#{super}_id"
    end

    def parent_node_node_type
      conf.parent_node_node_type
    end

    def nodes
      parent_node_node_type.nodes
    end
  end
end
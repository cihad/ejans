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

    def options_for_select
      options_for_select = nodes.published.map { |n| [n.title, n.id] }
      options_for_select.unshift(['', '']) unless required?
      options_for_select
    end
  end
end
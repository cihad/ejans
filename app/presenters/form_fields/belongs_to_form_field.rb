module FormFields
  class BelongsToFormField < FormField
    def form_key
      :"#{super}_id"
    end

    def can_be_added_only_by_belongs_to_node_author?
      conf.can_be_added_only_by_belongs_to_node_author?
    end

    def parent_node_node_type
      conf.parent_node_node_type
    end

    def nodes
      parent_node_node_type.nodes
    end

    def options_for_select(author = nil)
      if can_be_added_only_by_belongs_to_node_author?
        nodes = parent_node_node_type.nodes.where(author_id: author.try(:id))
        options_for_select = nodes.map { |node| [node.title, node.id] }
      else
        options_for_select = nodes.published.map { |n| [n.title, n.id] }
        options_for_select.unshift(['', '']) unless required?
      end

      options_for_select
    end
  end
end
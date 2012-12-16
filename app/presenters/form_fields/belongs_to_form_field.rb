module FormFields
  class BelongsToFormField < FormField
    def form_key
      :"#{super}_id"
    end

    def can_be_added_only_by_parent_author?
      field.can_be_added_only_by_parent_author?
    end

    def parent_klass
      field.class_name.constantize
    end

    def nodes
      parent_klass.all
    end

    def options_for_select(author = nil)
      if can_be_added_only_by_parent_author?
        nodes = self.nodes.where(author_id: author.try(:id)).published
        options_for_select = nodes.map { |node| [node.title, node.id] }
      else
        nodes = self.nodes.published
        options_for_select = nodes.map { |n| [n.title, n.id] }
        options_for_select.unshift(['', '']) unless required?
      end

      options_for_select
    end
  end
end
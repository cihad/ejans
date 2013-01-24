module FormFields
  class BelongsToFormField < FormField
    def form_key
      "#{super}_id".to_sym
    end

    delegate :can_be_added_only_by_parent_author?, :class_name, to: :field

    def nodes
      Node.where("_type" => class_name)
    end

    def include_blank?
      !required?
    end

    def options_for_select(author = nil)
      nodes = if can_be_added_only_by_parent_author?
                self.nodes.where(author_id: author.try(:id))
              else
                self.nodes.active
              end

      nodes.map { |n| [n.title, n.id] }
    end
  end
end
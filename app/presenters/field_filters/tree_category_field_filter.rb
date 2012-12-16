module FieldFilters
  class TreeCategoryFieldFilter < Filter
    def levels
      @levels ||= field.category.levels_unless_self
    end

    def form_machine_names
      field.class.tree_category_machine_names(field.to_recipe, levels.size)
    end
  end
end
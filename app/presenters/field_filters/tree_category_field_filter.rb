module FieldFilters
  class TreeCategoryFieldFilter < Filter

    delegate :category, to: :field

    def levels
      @levels ||= category.levels_unless_self
    end

    def form_machine_names
      field.class.tree_category_machine_names(field.to_recipe, levels.size)
    end
  end
end
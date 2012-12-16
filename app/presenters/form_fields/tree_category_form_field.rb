module FormFields
  class TreeCategoryFormField < FormField
    def category
      @category ||= field.category
    end

    def levels
      @levels ||= category.levels_unless_self
    end

    def category_ids_name
      :"#{keyname.to_s.singularize}_ids"
    end

    def category_ids
      node.send(category_ids_name)
    end
  end
end
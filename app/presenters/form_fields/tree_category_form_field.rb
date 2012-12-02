module FormFields
  class TreeCategoryFormField < FormField
    def category
      @category ||= conf.category
    end

    def levels
      @levels ||= conf.category_levels
    end

    def category_ids_name
      :"#{keyname.to_s.singularize}_ids"
    end
  end
end
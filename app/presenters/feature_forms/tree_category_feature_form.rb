module FeatureForms
  class TreeCategoryFeatureForm < FeatureForm
    def value
      :"#{key_name}_ids"
    end

    def category
      @category ||= conf.category
    end

    def levels
      @levels ||= conf.category_levels
    end

    def category_ids_name
      :"#{key_name.to_s.singularize}_ids"
    end
  end
end
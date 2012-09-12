module FeatureFilters
  class TreeCategoryFeatureFilter < Filter
    def levels
      @levels = conf.category_levels
    end

    def form_machine_names
      conf.form_machine_names
    end
  end
end
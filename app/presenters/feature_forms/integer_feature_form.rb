module FeatureForms
  class IntegerFeatureForm < FeatureForm
    def maximum
      conf.maximum
    end

    def minumum
      conf.minumum
    end

    def filter?
      conf.filter?
    end

    def filter_type
      conf.filter_type
    end
  end
end
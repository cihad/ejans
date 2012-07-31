module FeatureForms
  class IntegerFeatureForm < FeatureForm
    def maximum
      conf.maximum
    end

    def minimum
      conf.minimum
    end

    def filter?
      conf.filter?
    end

    def filter_type
      conf.filter_type
    end
  end
end
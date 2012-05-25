module FeatureViews
  class IntegerFeatureView < FeatureView
    def value
      feature.value
    end
  end
end
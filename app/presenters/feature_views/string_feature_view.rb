module FeatureViews
  class StringFeatureView < FeatureView
    def value
      feature.value
    end
  end
end
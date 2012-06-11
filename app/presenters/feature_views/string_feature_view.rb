module FeatureViews
  class StringFeatureView < FeatureView
    def value
      feature_tag do
        feature.value
      end
    end
  end
end
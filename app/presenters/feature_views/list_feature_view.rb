module FeatureViews
  class ListFeatureView < FeatureView
    def value
      feature_tag do
        feature.value
      end
    end
  end
end
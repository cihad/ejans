module FeatureViews
  class ListFeatureView < FeatureView
    def value
      feature_tag do
        feature.value.map(&:name).join(', ')
      end
    end
  end
end
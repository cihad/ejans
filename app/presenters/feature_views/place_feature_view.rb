module FeatureViews
  class PlaceFeatureView < FeatureView
    def value
      feature_tag do
        @template.content_tag :span, places
      end
    end

    def places
      feature.value.map(&:name).join(', ')
    end
  end
end
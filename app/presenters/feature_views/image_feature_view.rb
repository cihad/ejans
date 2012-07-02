module FeatureViews
  class ImageFeatureView < FeatureView
    def value
      feature_tag do
        @template.content_tag :span, images.html_safe
      end
    end

    def images
      feature.value.inject("") do |acc, img|
        acc << @template.image_tag(img.image_url, width: 200, height: 200)
        acc
      end
    end
  end
end
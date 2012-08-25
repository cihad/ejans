module Features
  class ImageFeatureConfiguration < FeatureConfiguration
    include Mongoid::Document
    field :maximum_image, type: Integer

    def data_names
      super + if maximum_image > 1
                [ :"#{machine_name}_thumb_image_urls",
                  :"#{machine_name}_small_image_urls",
                  :"#{machine_name}_original_image_urls"]
              else
                [ :"#{machine_name}_thumb_image_url",
                  :"#{machine_name}_small_image_url",
                  :"#{machine_name}_original_image_url"]
              end
    end
  end
end
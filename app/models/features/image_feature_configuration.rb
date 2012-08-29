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

    private

    def assign_key_name
      name_prefix = 0
      while key_names.include?(name = "#{I18n.with_locale(:en) { name_prefix.to_words }}_images".to_sym)
        name_prefix = name_prefix.next
      end
      name
    end
  end
end
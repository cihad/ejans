module Features
  class ImageFeatureConfiguration < FeatureConfiguration
    
    field :maximum_image, type: Integer, default: 1
    validates :maximum_image, presence: true
    
    def data_names
      super + if maximum_image > 1
        arr = [ :"#{machine_name}_original_image_urls" ]
        arr += [ :"#{machine_name}_thumb_image_urls"]
        arr += [ :"#{machine_name}_small_image_urls" ]
        arr += [ :"#{machine_name}_small_resize_to_width_image_urls" ]
        arr += [ :"#{machine_name}_medium_image_urls"]
        arr
      else
        arr = [ :"#{machine_name}_original_image_url" ]
        arr += [ :"#{machine_name}_thumb_image_url"]
        arr += [ :"#{machine_name}_small_image_url" ]
        arr += [ :"#{machine_name}_small_resize_to_width_image_url" ]
        arr += [ :"#{machine_name}_medium_image_url"]
        arr
      end
    end

    def data_for_node
      super.merge({
        :"#{machine_name}_maximum_image" => maximum_image
        })
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
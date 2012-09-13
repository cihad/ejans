module Features
  class ImageFeatureConfiguration < FeatureConfiguration
    
    field :maximum_image, type: Integer, default: 0
    field :versions, type: Array, default: []
    VERSION_TYPES = FeatureImageUploader.condition_versions_keys

    validate :correct_versions

    def data_names
      super + if maximum_image > 1
                arr = [ :"#{machine_name}_original_image_urls" ]
                arr += [ :"#{machine_name}_thumb_image_urls"]
                arr += [ :"#{machine_name}_small_image_urls" ] if small?
                arr += [ :"#{machine_name}_small_resize_to_width_image_urls" ] if small_resize_to_width?
                arr += [ :"#{machine_name}_medium_image_urls"] if medium?
                arr
              else
                arr = [ :"#{machine_name}_original_image_url" ]
                arr += [ :"#{machine_name}_thumb_image_url"]
                arr += [ :"#{machine_name}_small_image_url" ] if small?
                arr += [ :"#{machine_name}_small_resize_to_width_image_url" ] if small_resize_to_width?
                arr += [ :"#{machine_name}_medium_image_url"] if medium?
                arr
              end
    end

    VERSION_TYPES.each do |ver|
      define_method("#{ver}?") do
        versions.include?(ver)
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

    def correct_versions
      unless versions.all? { |ver| VERSION_TYPES.include?(ver) }
        error.add(:base, "Geverli bir versiyon girmediniz.")
      end
    end
  end
end
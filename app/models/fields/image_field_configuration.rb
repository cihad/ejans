module Fields
  class ImageFieldConfiguration < FieldConfiguration
    
    field :maximum_image, type: Integer, default: 1
    validates :maximum_image, presence: true

    def set_specifies
      Node.instance_eval <<-EOM
        embeds_many :#{keyname}, class_name: "Fields::Image",
          cascade_callbacks: true

        validate :#{keyname}_presence_value
        validate :#{keyname}_not_greater_than
      EOM

      Node.class_eval <<-EOM
        def #{machine_name}
          #{keyname}
        end

        def #{keyname}_add_images(params)
          params.inject([]) do |new_images, img|
            image = Fields::Image.new(image: img)
            # Validation Maximum Image Size
            if #{maximum_image} == 0 || #{keyname}.size < #{maximum_image}
              new_images << image
              result = #{keyname} << image
            end
            new_images
          end
        end
        
        private

        def #{keyname}_presence_value
          if #{required?} and #{keyname}.size == 0
            errors.add(:#{keyname}, "alani bos birakilamaz.")
          end
        end

        def #{keyname}_not_greater_than
          if #{maximum_image} and #{maximum_image} != 0 and #{keyname}.size > #{maximum_image}
            errors.add(:#{keyname}, "En fazla #{maximum_image} resim ekleyebilirsiniz.")
          end
        end
      EOM
    end

    private

    def assign_keyname
      name_prefix = 0
      while keynames.include?(name = "#{I18n.with_locale(:en) { name_prefix.to_words }}_images".to_sym)
        name_prefix = name_prefix.next
      end
      name
    end
  end
end
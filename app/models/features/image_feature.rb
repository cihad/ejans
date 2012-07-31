module Features
  class ImageFeature < Feature
    include Mongoid::Document

    get_method_from_conf :maximum_image

    def self.set_key(key_name)
      has_and_belongs_to_many :"#{key_name}",
        class_name: "Features::Image"
    end


    def add_images(params)
      params.inject([]) do |new_images, img|
        image = Features::Image.new({ image: img })
        image.node = node
        # Validation Maximum Image Size
        if value.size < maximum_image
          new_images << image
          value << image
          image.save
        end
        node.save
        new_images
      end
    end

    def delete_image(image)
      value.delete(image)
      image.destroy
    end

    validate :presence_value
    validate :not_greater_than

    private
    def presence_value
      if required? and value.size == 0
        add_error("#{conf.label} alani bos birakilamaz.")
      end
    end

    def not_greater_than
      if maximum_image and value.size > maximum_image
        add_error("En fazla #{maximum_image} resim ekleyebilirsiniz.")
      end
    end

  end
end
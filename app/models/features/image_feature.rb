module Features
  class ImageFeature < Feature
    include Mongoid::Document

    def self.set_key(key_name)
      has_and_belongs_to_many :"#{key_name}",
        class_name: "Features::Image"
    end

    def value
      send(conf.key_name)
    end

    def add_images(params)
      params.inject([]) do |new_images, img|
        image = Features::Image.new({ image: img })
        image.node = node
        # Validation Maximum Image Size
        if value.size < conf.maximum_image
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
  end
end
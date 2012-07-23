module Features
  class ImageFeature
    include Mongoid::Document
    # parent, configuration, child_configuration, required?
    include Ejans::Features::FeatureAbility

    # Associations
    embedded_in :feature, class_name: "Features::Feature"

    def add_images(params)
      params.inject([]) do |new_images, img|
        image = Features::Image.new({ image: img })
        image.node = feature.node
        # Validation Maximum Image Size
        if value.size < child_configuration.maximum_image
          new_images << image
          value << image
          image.save
        end
        new_images
      end
    end

    def delete_image(image)
      value.delete(image)
      image.destroy
    end

    def value
      send(parent.feature_configuration.value_name)
    end

    def self.add_value(name)
      has_and_belongs_to_many :"#{name}",
        class_name: "Features::Image"
    end
  end
end
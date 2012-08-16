module Features
  class ImageFeature < Feature
    include Mongoid::Document

    get_method_from_conf :maximum_image

    def self.set_key(key_name)
      embeds_many :"#{key_name}",
        class_name: "Features::Image"
    end

    def fill_random!
      dir = Rails.root
      images_dir = "#{dir}/spec/support/images"
      all_images = Dir.glob("#{images_dir}/*.jpg")
      ma = maximum_image || 10
      image_file_dirs = all_images.shuffle.take(rand(ma))
      images = image_file_dirs.each_with_index.inject([]) do |ary, (file, index)|
        image = Features::Image.new(image:File.new(file), position: (index + 1))
        ary << image
      end
      self.value << images
    end

    def add_images(params)
      params.inject([]) do |new_images, img|
        image = Features::Image.new({ image: img })
        # Validation Maximum Image Size
        if value.size < maximum_image
          new_images << image
          value << image
        end
        new_images
      end
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
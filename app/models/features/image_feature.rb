module Features
  class ImageFeature < Feature
    include Mongoid::Document

    get_method_from_conf :maximum_image

    def self.set_specify(conf)
      embeds_many conf.key_name,
        class_name: "Features::Image",
        cascade_callbacks: true
    end

    def data(conf_data)
      super
      maximum_select = @data[:"#{@machine_name}_maximum_select"]
      if maximum_select.nil? or maximum_select > 1
        h = { :"#{@machine_name}_original_image_urls" => @value.map { |img| img.image_url } }
        h.merge!(:"#{@machine_name}_thumb_image_urls" => @value.map { |img| img.image_url(:thumb) })
        h.merge!(:"#{@machine_name}_small_image_urls" => @value.map { |img| img.image_url(:small) })
        h.merge!(:"#{@machine_name}_small_resize_to_width_image_urls" => @value.map { |img| img.image_url(:small_resize_to_width) })
        h.merge!(:"#{@machine_name}_medium_image_urls" => @value.map { |img| img.image_url(:medium) })
      else
        h = { :"#{@machine_name}_original_image_url" => @value.first.image_url }
        h.merge!(:"#{@machine_name}_thumb_image_url" => @value.first.image_url(:thumb))
        h.merge!(:"#{@machine_name}_small_image_url" => @value.first.image_url(:small))
        h.merge!(:"#{@machine_name}_small_resize_to_width_image_url" => @value.first.image_url(:small_resize_to_width))
        h.merge!(:"#{@machine_name}_medium_image_url" => @value.first.image_url(:medium))
      end
      h
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
        image = Features::Image.new(image: img)
        # Validation Maximum Image Size
        if maximum_image == 0 || value.size < maximum_image
          new_images << image
          result = value << image
          binding.pry
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
      if maximum_image and maximum_image != 0 and value.size > maximum_image
        add_error("En fazla #{maximum_image} resim ekleyebilirsiniz.")
      end
    end

  end
end
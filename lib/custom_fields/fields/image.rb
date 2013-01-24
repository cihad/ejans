module CustomFields
  module Fields
    module Image



      module ApplyCustomField
        def apply_image_custom_field(klass, rule)
          klass.embeds_many rule['keyname'].to_sym,
            class_name: "::CustomFields::Fields::Image::Image",
            as: :imageable,
            cascade_callbacks: true

          klass.class_eval do
            define_method rule['machine_name'] do |version|
              Presenter.new(version, self.send(rule['keyname']), rule)
            end
          end

          klass.class_eval <<-EOM, __FILE__, __LINE__ + 1
            alias :#{rule['machine_name']}= :#{rule['keyname']}=
          EOM
        end
      end



      module ApplyValidate
        def apply_image_validate(klass, rule)
          if rule['required']
            klass.validates_presence_of rule['keyname'].to_sym
          end

          if rule['maximum_image'] and rule['maximum_image'] != 0
            klass.validates_length_of rule['keyname'].to_sym,
              maximum: rule['maximum_image']
          end

          klass.class_eval <<-EOM, __FILE__, __LINE__ + 1
            def #{rule['machine_name']}_add_images(params)
              params.inject([]) do |new_images, img|
                image = ::CustomFields::Fields::Image::Image.new(image: img)
                new_images << image
                result = #{rule['keyname']} << image
                new_images
              end
            end
          EOM
        end
      end



      class ImageUploader < ::CarrierWave::Uploader::Base
        include ::CarrierWave::RMagick
        extend ApplyCustomField
        extend ApplyValidate

        BASE_DIR = "uploads/nodes"

        def self.base_dir(parent_id)
          "#{BASE_DIR}/#{parent_id}"
        end

        def store_dir
          self.class.base_dir(model.imageable.id)
        end

        version :medium do
          process :resize_to_limit => [640, 480]
        end

        version :thumb do
          process :resize_to_limit => [96, 72]
        end

        version :small do
          process :resize_to_limit => [220, 165]
        end

        version :small_resize_to_width do
          process :resize_to_fit => [220, nil]
        end

        def extension_white_list
          %w(jpg jpeg gif png)
        end

        def filename
          "#{secure_token}.#{file.extension}" if original_filename
        end

        protected
        def secure_token
          var = :"@#{mounted_as}_secure_token"
          model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
        end
      end


      class Image
        include ::Mongoid::Document
        mount_uploader :image, ImageUploader
        field :position, type: ::Integer, default: 1000
        embedded_in :imageable, polymorphic: true
        default_scope order_by([:position, :asc])
      end



      class Field < ::CustomFields::Fields::Default::Field

        ## fields
        field :maximum_image, type: ::Integer, default: 1

        ## validations
        validates :maximum_image, presence: true

        def fill_node_with_random_value(node)
          max_img = maximum_image > 10 ? 10 : maximum_image
          images = Random.rand(1..maximum_image).times.inject([]) do |arr, i|
            arr << Image.new(imageable: node, image: File.new("#{Rails.root}/spec/support/images/home_#{i+1}.jpg"))
          end
          node.send("#{keyname}=", images)
        end

        def custom_recipe
          { 'maximum_image' => maximum_image }
        end

        private

        def assign_keyname
          name_prefix = 0
          while siblings.map(&:keyname).include?(name = "#{I18n.with_locale(:en) { name_prefix.to_words }}_images".to_sym)
            name_prefix = name_prefix.next
          end
          name
        end
      end



      class Presenter < ::CustomFields::Fields::Default::Presenter
        include Enumerable

        attr_reader :version

        def initialize(version = nil, *args)
          @version = version
          super *args
        end

        def [](key)
          images[key]
        end

        def to_a
          images.dup
        end

        def each(&block)
          images.each(&block)
        end

        def count
          images.size
        end

        private

        def images
          source.map { |image| image.image_url(version) }
        end
      end





    end
  end
end
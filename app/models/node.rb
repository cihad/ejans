class Node  
  include Mongoid::Document
  include Mongoid::Timestamps

  paginates_per 20

  # Fields
  field :title

  # Associations
  belongs_to :node_type
  embeds_many :features, class_name: "Features::Feature", cascade_callbacks: true
  accepts_nested_attributes_for :features
  validates_associated :features

  def find_value_by_views_feature(feature)
    fc = feature.feature_configuration
    features
      .find_by(:feature_configuration_id => fc.id)
  end

  def delete_image(img)
    images.delete(img)
  end

  def images
    child_image_feature.send(feature_with_image.feature_configuration.value_name)
  end

  def add_images(params)
    images = params[:features_image][:image].inject([]) do |images, image|
      image = Features::Image.new({ image: image })
      image.node = self
      images << image if image.save
    end

    self.images << images
    images
  end

  def feature_with_image
    features.detect { |fea| fea.type == "image_feature" }
  end

  def child_image_feature
    feature_with_image.image_feature
  end

  # Associations builer (used by the controller)
  def build_assoc!
    node_type.feature_configurations.each do |fea_conf|
      fea_conf.child.build_assoc!(self)
    end
  end

  after_initialize :build_values

  def build_values
    node_type.feature_configurations.each do |fea_conf|
      fea_conf.add_value_to_feature!
    end
  end
end
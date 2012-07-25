class Node
  include Mongoid::Document
  include Mongoid::Timestamps

  paginates_per 20

  # Fields
  field :title
  field :published, type: Boolean, default: false
  field :approved, type: Boolean, default: false

  # Scopes
  scope :queue, where(published: true, approved: false)
  scope :unpublished, where(published: false)
  scope :publishing, where(published: true, approved: true)

  # Associations
  belongs_to :node_type
  embeds_many :features, class_name: "Features::Feature"
  accepts_nested_attributes_for :features

  def publish=(value)
    self.published = true
    self.approved = false
  end

  def find_value_by_views_feature(feature)
    fcid = feature.feature_configuration_id
    features.where(feature_configuration_id: fcid).first
  end

  # [<Features::Image..>, <Features::Image..>, ...]
  def images
    feature_with_image.send(feature_with_image.conf.key_name)
  end

  # <Features::Feature...>
  def feature_with_image
    features.detect { |fea| fea._type == "Features::ImageFeature" }
  end

  # Associations builer (used by the controller)
  def build_assoc!
    node_type.feature_configurations.each do |fea_conf|
      fea_conf.build_assoc!(self)
    end
  end

  def node_type=(node_type)
    self.node_type_id = node_type.id
    build_assoc!
  end

  after_initialize :build_values

  private
  def build_values
    build_assoc! if node_type
  end
end
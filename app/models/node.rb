class Node
  include Mongoid::Document
  include Mongoid::Timestamps
  include Rails.application.routes.url_helpers

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

  def data
    { :node_title => title,
      :node_url => node_type_node_path(node_type, self),
      :node_created_at => created_at,
      :node_updated_at => updated_at }
  end

  def self.data_names
    [:node_title, :node_url, :node_crated_at, :node_updated_at]
  end

  def mapping(conf_data)
    features_data = features.inject({}) do |hash, feature|
      hash.merge!(feature.data(conf_data))
    end

    node_data = data.merge(features_data)

    conf_data = conf_data.inject({}) do |hash, conf|
      hash.merge!(conf.last[:data])
    end

    node_data.merge(conf_data)
  end

  # Associations builer (used by the controller)
  def build_assoc!
    node_type.feature_configurations.each do |conf|
      conf.build_assoc!(self)
    end
  end

  def fill_random!
    features.each do |f|
      f.fill_random!
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
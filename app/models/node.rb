class Node
  include Mongoid::Document
  include Mongoid::Timestamps

  paginates_per 20

  # Fields
  field :title

  # Associations
  belongs_to :node_type
  embeds_many :features, class_name: "Features::Feature"
  accepts_nested_attributes_for :features
  validates_associated :features

  def find_value_by_views_feature(feature)
    fc = feature.feature_configuration
    features
      .find_by(:feature_configuration_id => fc.id)
  end

  # Associations builer (used by the controller)
  def build_assoc!
    node_type.feature_configurations.each do |fea_conf|
      if self.features.map(&:feature_configuration_id).include?(fea_conf.id)
        feature = self.features.where(feature_configuration_id: fea_conf.id.to_s).first
      else
        feature = self.features.build
        feature.feature_configuration = fea_conf
        feature.send("build_#{fea_conf.feature_type}")
      end

      feature.child.class.add_value(fea_conf.value_name)
    end
  end

  after_initialize :build_values

  def build_values
    unless new_record?
      node_type.feature_configurations.each do |fea_conf|
        fea_conf.add_value_to_feature!
      end
    end
  end
end
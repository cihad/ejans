class Node
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title
  belongs_to :node_type
  embeds_many :features, class_name: "Features::Feature"
  accepts_nested_attributes_for :features
  validates_associated :features

  def build_assoc!
    node_type.feature_configurations.each do |fea_conf|
      if self.features.map(&:feature_configuration_id).include?(fea_conf.id)
        feature = self.features.where(feature_configuration_id: fea_conf.id.to_s).first
      else
        feature = self.features.build
        feature.feature_configuration = fea_conf
        feature.send("build_#{fea_conf.feature_type}")
      end
      feature.feature_object.class.add_value(fea_conf.value_name)
    end
  end
end
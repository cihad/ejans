module Views
  class Table < View
    attr_accessor :conf_id
    
    embeds_many :features, class_name: "Views::Feature"
    accepts_nested_attributes_for :features

    def conf_id=(id)
      self.features.build(feature_configuration_id: Features::FeatureConfiguration.find(id).id, position: 10)
    end

    def name
      "table"
    end

    def build_assoc!
      node_type.feature_configurations.each_with_index do |fc, i|
        feature = self.features.build
        feature.feature_configuration = fc
        feature.position = i+1
      end
    end
  end
end
module Features
  class Feature
    include Mongoid::Document

    # Associations
    embedded_in :node
    belongs_to :feature_configuration, class_name: "Features::FeatureConfiguration", autosave: true

    FEATURE_TYPES = [:integer, :string]
    FEATURE_TYPES.each do |feature_type|
      embeds_one :"#{feature_type}_feature", class_name: "Features::#{feature_type.to_s.camelize}Feature"
      accepts_nested_attributes_for :"#{feature_type}_feature"
    end

    before_save :define_feature_configuration

    # Feature Configuration Type
    # => "integer_feature"
    def type
      self.reflect_on_all_associations(:embeds_one).map(&:key).inject("") do |s, assoc|
        s << assoc if self.send(assoc)
        s
      end
    end

    # Feature's Feature Object
    # => #<Features::IntegerFeature _id:...>
    def feature_object
      send(type)
    end

    # for example for integer feature:
    # in database:
    # features: { "integer_feature": { integer_value_0: 10 } }
    # result:
    # => 10
    def value
      feature_object.value
    end

    private
    def define_feature_configuration
      self.feature_configuration = NodeType.feature_configurations.find(feature_configuration_id)
    end
  end
end
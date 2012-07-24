module Features
  class Feature
    include Mongoid::Document

    attr_reader :key_name

    @@key = :initial_symbol

    # Associations
    embedded_in :node
    belongs_to :feature_configuration,
      class_name: "Features::FeatureConfiguration"

    before_save :define_feature_configuration

    after_initialize :set_keys

    def self.add_key(key_name)
      @@key = key_name
    end

    def required?
      feature_configuration.required?
    end

    def add_error(message = "")
      errors.add(key_name, message)
      node.errors.add(:base, message)
    end

    private
    def set_keys
      @key_name = @@key
    end

    def define_feature_configuration
      self.feature_configuration =
        Features::FeatureConfiguration.find(feature_configuration.id)
    end
  end
end
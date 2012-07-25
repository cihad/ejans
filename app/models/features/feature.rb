module Features
  class Feature
    include Mongoid::Document

    embedded_in :node
    belongs_to :feature_configuration,
      class_name: "Features::FeatureConfiguration"

    alias :conf :feature_configuration

    before_save :define_feature_configuration

    def self.to_feature(class_name)
      name = class_name.to_s.demodulize.titleize.split(' ')
      name.pop
      name.join
    end

    def conf
      feature_configuration
    end

    def required?
      feature_configuration.required?
    end

    def add_error(message = "")
      errors.add(conf.key_name, message)
      node.errors.add(:base, message)
    end

    private
    def define_feature_configuration
      self.feature_configuration =
        Features::FeatureConfiguration.find(feature_configuration.id)
    end
  end
end
module FeatureViews
  class FeatureView
    def initialize(feature, template)
      self.feature = feature
      @template = template
    end

    attr_accessor :feature

    def feature_configuration
      feature.feature_configuration
    end

    def type
      feature_configuration.feature_type
    end

    def to_s
      @template.render "features/#{type.downcase}_view", feature: self
    end

    def label
      feature_configuration.label
    end

    def self.feature_presenter_class(feature)
      "FeatureViews::#{feature.feature_configuration.feature_type.camelize}View".constantize
    end
  end
end
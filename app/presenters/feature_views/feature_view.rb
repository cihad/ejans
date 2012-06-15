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

    def machine_name
      feature_configuration.machine_name
    end

    def child
      feature_configuration.child
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

    def feature_tag(&block)
      @template.content_tag :span, class: "feature_#{machine_name}", &block
    end
  end
end
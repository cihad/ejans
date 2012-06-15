module FeatureForms
  class FeatureForm
    attr_accessor :feature

    def initialize(feature_form_element, template)
      self.feature = feature_form_element
      @template = template
    end

    def form_element
      feature
    end

    def object
      feature.object
    end

    def object_class
      object.class
    end

    def feature_configuration
      object.feature_configuration
    end

    def child
      feature_configuration.child
    end

    def child_feature
      object.child_feature
    end

    def type
      feature_configuration.feature_type
    end

    def label
      feature_configuration.label.to_s
    end

    def to_s
      @template.render "features/#{type}_form", feature: self
    end

    def self.form_presenter_class(form_element)
      "FeatureForms::#{form_element.object.feature_configuration.feature_type.camelize}Form".constantize
    end
  end
end
module FeatureFilters
  class Filter
    attr_accessor :feature_configuration

    def initialize(feature_configuration, template)
      self.feature_configuration = feature_configuration
      @template = template
    end

    def feature_type
      feature_configuration.feature_type
    end

    def child
      feature_configuration.child
    end

    def filter_type
      child.filter_type
    end

    def machine_name
      feature_configuration.machine_name.to_sym
    end

    def to_s
      @template.render "features/#{feature_type}_filter", feature: self
    end

    def label
      feature_configuration.label
    end

    def self.presenter_class(feature_configuration)
      "FeatureFilters::#{feature_configuration.feature_type.camelize}Filter".constantize
    end
  end
end
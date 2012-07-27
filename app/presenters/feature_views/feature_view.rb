module FeatureViews
  class FeatureView
    def initialize(feature, template)
      self.feature = feature
      @template = template
    end

    attr_accessor :feature

    def conf
      feature.conf
    end

    def machine_name
      conf.machine_name
    end

    def type
      conf.feature_type
    end

    def to_s
      @template.render "features/#{conf.partial_dir}/view", feature: self
    end

    def label
      conf.label
    end

    def self.feature_presenter_class(feature)
      "FeatureViews::#{feature.conf.feature_type.camelize}FeatureView".constantize
    end

    def feature_tag(&block)
      @template.content_tag :span, class: "feature_#{machine_name}", &block
    end
  end
end
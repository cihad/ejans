module FeatureFilters
  class Filter
    attr_accessor :conf

    def initialize(conf, template)
      self.conf = conf
      @template = template
    end

    def feature_type
      conf.feature_type
    end

    def filter_type
      conf.filter_type
    end

    def machine_name
      conf.machine_name.to_sym
    end

    def to_s
      @template.render "#{conf.partial_dir}/filter", feature: self
    end

    def label
      conf.label
    end

    def self.presenter_class(conf)
      "FeatureFilters::#{conf.feature_type.camelize}FeatureFilter".constantize
    end
  end
end
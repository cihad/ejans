module FeatureFilters
  class Filter
    attr_accessor :conf

    def initialize(conf, template)
      self.conf = conf
      @template = template
    end

    def position
      conf.node_type.filters_position
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
<<<<<<< HEAD
      @template.render "#{conf.partial_dir}/#{position}_filter", feature: self
=======
      @template.render "#{conf.partial_dir}/#{@position}_filter", feature: self
>>>>>>> node-view
    end

    def label
      conf.label
    end

    def self.presenter_class(conf)
      "FeatureFilters::#{conf.feature_type.camelize}FeatureFilter".constantize
    end
  end
end
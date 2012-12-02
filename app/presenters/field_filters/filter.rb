module FieldFilters
  class Filter
    attr_accessor :conf

    def initialize(conf, template)
      self.conf = conf
      @template = template
    end

    def position
      conf.node_type.filters_position
    end

    def field_type
      conf.field_type
    end

    def filter_type
      conf.filter_type
    end

    def machine_name
      conf.machine_name.to_sym
    end

    def to_s
      @template.render "#{conf.partial_dir}/#{position}_filter", field: self
    end

    def label
      conf.label
    end

    def self.presenter_class(conf)
      "FieldFilters::#{conf.field_type.camelize}FieldFilter".constantize
    end
  end
end
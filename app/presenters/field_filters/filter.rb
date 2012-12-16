module FieldFilters
  class Filter
    attr_accessor :field

    def initialize(field, template)
      @field = field
      @template = template
    end

    def position
      field.node_type.filters_position
    end

    def type
      field.type
    end

    def filter_type
      field.filter_type
    end

    def machine_name
      field.machine_name.to_sym
    end

    def to_s
      @template.render "custom_fields/fields/types/#{field.type}/#{position}_filter", field: self
    end

    def label
      field.label
    end

    def self.presenter_class(field)
      "FieldFilters::#{field.type.camelize}FieldFilter".constantize
    end
  end
end
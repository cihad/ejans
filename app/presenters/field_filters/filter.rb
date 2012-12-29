module FieldFilters
  class Filter < BasePresenter

    presents :field

    delegate :type, :filter_type, :machine_name, :label, to: :field

    def position
      field.node_type.filters_position
    end

    def to_s
      render "custom_fields/fields/types/#{field.type}/#{position}_filter", field: self
    end

    def self.presenter_class(field)
      "FieldFilters::#{field.type.camelize}FieldFilter".constantize
    end
  end
end
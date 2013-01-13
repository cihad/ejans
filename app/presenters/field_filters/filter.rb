module FieldFilters
  class Filter < BasePresenter

    presents :field

    delegate :type, :filter_type, :machine_name, :label, to: :field

    def to_s
      render "custom_fields/fields/types/#{field.type}/filter", field: self
    end

    def self.present(field, context)
      "FieldFilters::#{field.type.camelize}FieldFilter".constantize.new(field, context)
    end
  end
end
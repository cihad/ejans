module FieldFilters
  class SelectFieldFilter < Filter
    def select_options
      field.select_options
    end
  end
end
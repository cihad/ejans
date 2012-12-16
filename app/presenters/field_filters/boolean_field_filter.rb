module FieldFilters
  class BooleanFieldFilter < Filter
    def on_value
      field.on_value
    end

    def off_value
      field.off_value
    end
  end
end
module FieldFilters
  class BooleanFieldFilter < Filter
    def on_value
      conf.on_value
    end

    def off_value
      conf.off_value
    end
  end
end
module FormFields
  class BooleanFormField < FormField
    def on_value
      field.on_value
    end

    def off_value
      field.off_value
    end

    def widget_type
      field.widget_type
    end
  end
end
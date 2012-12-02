module FormFields
  class BooleanFormField < FormField
    def on_value
      conf.on_value
    end

    def off_value
      conf.off_value
    end

    def widget_type
      conf.widget_type
    end
  end
end
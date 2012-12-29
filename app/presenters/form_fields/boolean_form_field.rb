module FormFields
  class BooleanFormField < FormField
    delegate :on_value, :off_value, :widget_type, to: :field
    
  end
end
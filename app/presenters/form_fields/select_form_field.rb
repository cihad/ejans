module FormFields
  class SelectFormField < FormField

    delegate :maximum_select, to: :field

    def form_key
      :"#{machine_name}_ids"
    end
  end
end
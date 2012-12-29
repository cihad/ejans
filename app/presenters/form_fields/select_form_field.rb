module FormFields
  class SelectFormField < FormField

    delegate :maximum_select, to: :field

    def form_key
      :"#{keyname}_ids"
    end

    def list_item_ids_name
      :"#{keyname.to_s.singularize}_ids"
    end
  end
end
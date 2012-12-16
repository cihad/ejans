module FormFields
  class SelectFormField < FormField
    def form_key
      :"#{keyname}_ids"
    end

    def list_item_ids_name
      :"#{keyname.to_s.singularize}_ids"
    end

    def maximum_select
      field.maximum_select
    end
  end
end
module FormFields
  class TagFormField < FormField
    def form_key
      :"#{keyname}_tags"
    end
  end
end
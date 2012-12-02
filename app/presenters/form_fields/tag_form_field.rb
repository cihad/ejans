module FormFields
  class TagFormField < FormField
    def form_key
      :"#{super}_tags"
    end
  end
end
module FormFields
  class ImageFormField < FormField

    delegate :maximum_image, to: :field

    def images
      value
    end

    def info
      if maximum_image != 0
        content_tag :span, "En fazla #{maximum_image} resim eklebilirsiniz."
      end
    end
  end
end
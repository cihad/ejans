module FormFields
  class ImageFormField < FormField
    def maximum_image
      conf.maximum_image
    end

    def images
      value
    end
  end
end
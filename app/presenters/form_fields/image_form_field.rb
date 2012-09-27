module FormFields
  class ImageFormField < FormField
    def maximum_image
      conf.maximum_image
    end

    def images
      value
    end

    def info
      if maximum_image != 0
        @template.content_tag :span, <<-EOM
          En fazla #{maximum_image} resim eklebilirsiniz.
        EOM
      end
    end
  end
end
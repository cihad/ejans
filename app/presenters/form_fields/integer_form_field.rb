module FormFields
  class IntegerFormField < FormField
    def maximum
      field.maximum
    end

    def minimum
      field.minimum
    end

    def filter?
      field.filter?
    end

    def filter_type
      field.filter_type
    end

    def suffix
      field.suffix
    end

    def placeholder
      if minimum and maximum
        "#{minimum}-#{maximum} arasi bir deger giriniz."
      elsif maximum
        "#{maximum}'a esit veya daha kucuk bir deger giriniz."
      elsif minimum and minimum != 0
        "#{minimum}'a esit veya daha buyuk bir deger giriniz."
      end          
    end
  end
end
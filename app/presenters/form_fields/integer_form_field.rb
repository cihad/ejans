module FormFields
  class IntegerFormField < FormField
    def maximum
      conf.maximum
    end

    def minimum
      conf.minimum
    end

    def filter?
      conf.filter?
    end

    def filter_type
      conf.filter_type
    end

    def suffix
      conf.suffix
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
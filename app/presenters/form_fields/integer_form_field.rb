module FormFields
  class IntegerFormField < FormField

    delegate :maximum, :minimum, :filter?, :filter_type, :suffix, to: :field

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
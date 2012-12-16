module FormFields
  class StringFormField < FormField
    def text_field?
      field.row == 1 ? true : false
    end

    def row
      field.row
    end

    def max
      field.maximum_length
    end

    def min
      field.minimum_length
    end
  end
end
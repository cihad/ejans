module FormFields
  class StringFormField < FormField

    delegate :row, :maximum_length, :minimum_length, to: :field
    alias :max :maximum_length
    alias :min :minimum_length

    def text_field?
      row == 1 ? true : false
    end

  end
end
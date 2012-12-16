module FieldFilters
  class DateFieldFilter < Filter
    def start_machine_name
      "#{machine_name}_start".to_sym
    end

    def end_machine_name
      "#{machine_name}_end".to_sym
    end

    def start_year
      field.start_year
    end

    def end_year
      field.end_year
    end
  end
end
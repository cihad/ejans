module FieldFilters
  class SelectFieldFilter < Filter

    delegate :select_options, to: :field
    
  end
end
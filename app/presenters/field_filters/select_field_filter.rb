module FieldFilters
  class SelectFieldFilter < Filter

    delegate :options, to: :field
    
  end
end
module FieldFilters
  class BooleanFieldFilter < Filter

    delegate :on_value, :off_value, to: :field

  end
end
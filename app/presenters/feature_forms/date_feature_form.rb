module FeatureForms
  class DateFeatureForm < FeatureForm
    def value
      feature_configuration.value_name.to_sym
    end
    
    def start_year
      child.start_year
    end

    def end_year
      child.end_year
    end

    def prompt
      case child.date_type
      when :year
        { year: "Select year", month: false, day: false }
      when :year_month
        { year: "Select year", month: "Selecy month", day: false }
      when :year_month_day
        { year: "Select year", month: "Selecy month", day: "Select day" }
      end
    end

    def discards
      case child.date_type
      when :year
        { discard_month: true, discard_day: true }
      when :year_month
        { discard_day: true }
      when :year_month_day
        { }
      end
    end

    [:year, :month, :day].each do |time|
      define_method(:"discard_#{time}") do
        if child.date_type.to_s.split("_").include?(time.to_s)
          false
        else
          true
        end
      end
    end
  end
end
module FeatureForms
  class DateFeatureForm < FeatureForm
    def start_year
      conf.start_year
    end

    def end_year
      conf.end_year
    end

    def prompt
      case conf.date_type
      when :year
        { year: "Select year", month: false, day: false }
      when :year_month
        { year: "Select year", month: "Selecy month", day: false }
      when :year_month_day
        { year: "Select year", month: "Selecy month", day: "Select day" }
      end
    end

    def discards
      case conf.date_type
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
        if conf.date_type.to_s.split("_").include?(time.to_s)
          false
        else
          true
        end
      end
    end
  end
end
module FormFields
  class DateFormField < FormField

    delegate :start_year, :end_year, :date_type, to: :field

    def prompt
      case date_type
      when :year
        { year: "Select year" }
      when :year_month
        { year: "Select year", month: "Select month" }
      when :year_month_day
        { year: "Select year", month: "Select month", day: "Select day" }
      end
    end

    def discards
      case date_type
      when :year
        { discard_month: true, discard_day: true }
      when :year_month
        { discard_day: true }
      when :year_month_day
        { }
      end
    end

    def default_year
      now_year = Time.now.utc.to_date.year
      now_year < end_year ? now_year : end_year
    end

    [:year, :month, :day].each do |time|
      define_method(:"discard_#{time}") do
        if date_type.to_s.split("_").include?(time.to_s)
          false
        else
          true
        end
      end
    end
  end
end
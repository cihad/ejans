module FeatureViews
  class DateFeatureView < FeatureView
    def value
      feature_tag do
        @template.content_tag :span, pretty_value
      end
    end

    def plain_value
      feature.value
    end

    def pretty_value
      case child.date_type
      when :year
        plain_value.year
      when :year_month
        "#{plain_value.year}-#{plain_value.month}"
      when :year_month_date
        plain_value
      end
    end
  end
end
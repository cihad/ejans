module FeatureViews
  class IntegerFeatureView < FeatureView
    def value
      feature_tag do
        pres
      end
    end

    def plain_value
      feature.value
    end

    def prefix
      child.prefix
    end

    def suffix
      child.suffix
    end

    def thousand_marker
      child.thousand_marker
    end

    def pres
      @template.content_tag(:span, prefix, class: "prefix") +
      @template.number_with_delimiter(plain_value, delimiter: thousand_marker) +
      @template.content_tag(:span, suffix, class: "suffix")
    end
  end
end
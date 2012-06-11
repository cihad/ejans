module FeatureViews
  class IntegerFeatureView < FeatureView
    def value
      feature_tag do
        @template.send(view_type, plain_value, pres)
      end
    end

    def plain_value
      feature.value
    end

    def view_type
      configuration_object.view_type
    end

    def pres
      Features::IntegerFeatureConfiguration.options_for_view_types[view_type].inject({}) do |a, opt|
        a[opt] = configuration_object.send(opt) unless opt.nil?
        a
      end
    end
  end
end
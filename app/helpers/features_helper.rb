module FeaturesHelper
  def feature_form_for(feature_form_element)
    object_class = FeatureForms::FeatureForm.form_presenter_class(feature_form_element)
    presenter = object_class.new(feature_form_element, self)
    if block_given?
      yield presenter
    else
      presenter
    end
  end

  def feature_view(feature)
    presenter_class = FeatureViews::FeatureView.feature_presenter_class(feature)
    presenter = presenter_class.new(feature, self)
    if block_given?
      yield presenter
    else
      presenter
    end
  end

  def filter_for(feature_configuration)
    object_class = FeatureFilters::Filter.presenter_class(feature_configuration)
    presenter = object_class.new(feature_configuration, self)
    if block_given?
      yield presenter
    else
      presenter
    end
  end

end
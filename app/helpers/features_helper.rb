module FeaturesHelper
  def feature_form_for(form_builder)
    object_class = FeatureForms::FeatureForm.form_presenter_class(form_builder)
    object_class.new(form_builder, self)
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

  def check_box_option_for(selector)
    javascript_tag "new CheckBoxOption( $('[data-toggle=#{selector}]'))"
  end

  def select_option_for(selector)
    javascript_tag "new SelectOption( '#{selector}' )"
  end

  def to_feature_name(class_name)
    name = class_name.to_s.demodulize.titleize.split(' ')
    name.pop(2)
    name.join(' ')
  end
end
module FieldsHelper
  def field_form_for(f)
    object_class = FieldForms::FieldForm.form_presenter_class(f)
    object_class.new(f, self)
  end

  def filter_for(field_configuration)
    object_class = FieldFilters::Filter.presenter_class(field_configuration)
    presenter = object_class.new(field_configuration, self)
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

  def to_field_name(class_name)
    name = class_name.to_s.demodulize.titleize.split(' ')
    name.pop(2)
    name.join(' ')
  end

  def multiselect(selector, label = "Seciniz")
    javascript_tag <<-EOM
      $('#{selector}').multiselect({
        noneSelectedText: '#{label}',
        header: false,
        selectedList: 2,
        minWidth: 200,
      });
    EOM
  end
end
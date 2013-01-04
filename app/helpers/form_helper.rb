module FormHelper

  def horizontal_form_for(object, *args, &block)
    options = args.extract_options!
    options[:html] = {:class => "form-horizontal"}
    simple_form_for(object, *(args << options), &block)
  end

end
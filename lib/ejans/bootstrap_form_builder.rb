class BootstrapFormBuilder < ActionView::Helpers::FormBuilder
  def form_for(record, options = {}, &proc)
    @template.content_tag :div, class: "cihad" do 
      super
    end
  end

  def field_item(attribute, text = nil, &block)
    classes = ['control-group']
    classes << 'error' if @object.errors[attribute].any?
    classes = classes.join(' ')
    @template.content_tag :div, class: classes do
      @template.concat @template.label_tag(attribute, text, class: 'control-label')
      @template.content_tag :div, class: 'controls' do
        yield
        @template.concat errors_on(attribute)
      end
    end
  end

  def text_field_item(attribute, *args)
    field = @template.text_field_tag(attribute, @object.send(attribute), *args)
    field_item attribute do
      field
    end
  end

  def email_field_item(attribute, *args)
    field = @template.email_field_tag(attribute, @object.send(attribute), *args)
    field_item attribute do
      @template.concat field
    end
  end

  def number_field_item(attribute, *args)
    field = @template.number_field_tag(attribute, @object.send(attribute), *args)
    field_item attribute do
      @template.concat field
    end
  end

  def range_field_item(attribute, *args)
    field = @template.range_field_tag(attribute, @object.send(attribute), *args)
    field_item attribute do
      @template.concat field
    end
  end

  def errors_on(attribute)
    if @object.errors[attribute].any?
      @template.content_tag(:span,
        @object.errors[attribute].to_sentence,
        class: 'help-inline'
      )
    end
  end
end
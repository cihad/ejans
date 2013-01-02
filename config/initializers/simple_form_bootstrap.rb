# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.wrappers :bootstrap, :tag => 'div', :class => 'control-group', :error_class => 'error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper :tag => 'div', :class => 'controls' do |ba|
      ba.use :input
      ba.use :error, :wrap_with => { :tag => 'span', :class => 'help-inline' }
      ba.use :hint,  :wrap_with => { :tag => 'p', :class => 'help-block' }
    end
  end

  config.wrappers :prepend, :tag => 'div', :class => "control-group", :error_class => 'error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper :tag => 'div', :class => 'controls' do |input|
      input.wrapper :tag => 'div', :class => 'input-prepend' do |prepend|
        prepend.use :input
      end
      input.use :hint,  :wrap_with => { :tag => 'span', :class => 'help-block' }
      input.use :error, :wrap_with => { :tag => 'span', :class => 'help-inline' }
    end
  end

  config.wrappers :append, :tag => 'div', :class => "control-group", :error_class => 'error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper :tag => 'div', :class => 'controls' do |input|
      input.wrapper :tag => 'div', :class => 'input-append' do |append|
        append.use :input
      end
      input.use :hint,  :wrap_with => { :tag => 'span', :class => 'help-block' }
      input.use :error, :wrap_with => { :tag => 'span', :class => 'help-inline' }
    end
  end

  config.wrappers :single_image, :tag => 'div', :class => 'control-group', :error_class => 'error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper :tag => 'div', :class => 'controls' do |ba|
      b.wrapper :tag => 'div', :class => 'row' do |bb|
        bb.wrapper :tag => 'div', :class => 'span2' do |bc|
          bc.optional :image
        end
        bb.wrapper :tag => 'div', :class => 'span2' do |bc|
          bc.use :input
        end
      end
      ba.use :error, :wrap_with => { :tag => 'span', :class => 'help-inline' }
      ba.use :hint,  :wrap_with => { :tag => 'p', :class => 'help-block' }
    end
  end

  config.wrappers :embedded_fields, :tag => 'p', :error_class => 'error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :input
    b.use :error, :wrap_with => { :tag => 'span', :class => 'help-inline' }
    b.use :hint,  :wrap_with => { :tag => 'p', :class => 'help-block' }
  end



  # Wrappers for forms and inputs using the Twitter Bootstrap toolkit.
  # Check the Bootstrap docs (http://twitter.github.com/bootstrap)
  # to learn about the different styles for forms and inputs,
  # buttons and other elements.
  config.default_wrapper = :bootstrap

  config.label_class = 'control-label'
  config.form_class = 'simple_form form-horizontal'
end


module ::SimpleForm::Components::SingleImage
  # Name of the component method
  def image
    @image_url ||= begin
      if options[:image_url].present?
        template.content_tag :div, class: 'thumbnail' do
          template.image_tag options[:image_url]
        end
      end
    end
  end
  
  # Used when the image url is optional
  def has_image?
    image.present?
  end
end

::SimpleForm::Inputs::Base.send(:include, ::SimpleForm::Components::SingleImage)

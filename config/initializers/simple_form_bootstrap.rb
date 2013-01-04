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
        append.use :append
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

  config.wrappers :ace, :tag => 'div', :class => 'control-group', :error_class => 'error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper :tag => 'div', :class => 'controls' do |ba|
      ba.use :input
      ba.use :ace_editor
      ba.use :error, :wrap_with => { :tag => 'span', :class => 'help-inline' }
      ba.use :hint,  :wrap_with => { :tag => 'p', :class => 'help-block' }
    end
  end


  config.default_wrapper = :bootstrap

  config.label_class = 'control-label'
  config.form_class = 'simple_form'
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

module ::SimpleForm::Components::AceEditor
  def ace_editor
    @ace_editor ||= begin
      height = options[:ace].delete(:height) || 300
      width  = options[:ace].delete(:width) || 450
      id     = options[:ace].delete(:for)

      "<div style='height: #{height}px'>
        <div id='#{id}_editor'
             style='height: #{height}px; width: #{width}px'>
        </div>
      </div>" +
      ace_generator(@builder, id, options[:ace])
    end
  end

  def ace_generator(f, field, options = {})
    mode        = options.delete(:mode) || "html"
    class_name  = f.object.class.name.underscore.gsub('/', '_')
    selector    = "#{class_name}_#{field}"
    area        = "#{field}_editor"
    <<-JS
      <script type="text/javascript">
        $(function(){
          var #{area} = ace.edit("#{area}");
          #{area}.setTheme("ace/theme/chrome");
          #{area}.getSession().setFoldStyle("manual");
          #{area}.getSession().setMode("ace/mode/#{mode}");
          #{area}.setHighlightActiveLine(false);
          var #{area}_textarea = $('##{selector}').hide();
          #{area}.getSession().setValue(#{area}_textarea.val());
          #{area}.getSession().on('change', function(){
            #{area}_textarea.val(#{area}.getSession().getValue());
          });
        });
      </script>
    JS
  end
end

module ::SimpleForm::Components::Append
  def append
    @append ||= begin
      if options[:append].present?
        "<span class='add-on'>#{options[:append]}</span>"
      end
    end
  end

  def has_append?
    append.presend?
  end
end

::SimpleForm::Inputs::Base.send(:include, ::SimpleForm::Components::SingleImage)
::SimpleForm::Inputs::Base.send(:include, ::SimpleForm::Components::AceEditor)
::SimpleForm::Inputs::Base.send(:include, ::SimpleForm::Components::Append)


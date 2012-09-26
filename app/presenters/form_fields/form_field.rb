module FormFields
  class FormField
    attr_reader :f, :conf

    def initialize(f, conf, template)
      @f = f
      @conf = conf
      @template = template
    end

    def keyname
      conf.keyname
    end

    def form_key
      keyname
    end

    def node
      @node ||= f.object
    end

    def value
      node.send(keyname)
    end

    def label
      conf.label
    end

    def required?
      conf.required
    end

    def help_text
      @template.content_tag :span,
        conf.help_text.html_safe,
        class: "help-block"
    end

    def to_s
      @template.render "#{conf.partial_dir}/form", field: self
    end

    def self.form_presenter_class(conf)
      ( 
        "FormFields::" +
        conf.field_class_style_type_name +
        "FormField"
      ).safe_constantize
    end 
  end
end
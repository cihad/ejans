module FormFields
  class FormField
    attr_reader :f, :field

    def initialize(form_builder, field, template)
      @f = form_builder
      @field = field
      @template = template
    end

    def keyname
      field.keyname
    end

    def form_key
      machine_name
    end

    def node
      @node ||= f.object
    end

    def value
      node.send(keyname)
    end

    def label
      field.label
    end

    def machine_name
      field.machine_name
    end

    def required?
      field.required
    end

    def hint
      @template.content_tag :span,
        field.hint.html_safe,
        class: "help-block"
    end

    def partial_dir
      "custom_fields/fields/types/#{field.type}/form"
    end

    def to_s
      @template.render partial_dir, field: self
    end

    def self.form_presenter_klass(field)
      "FormFields::#{field.type.classify}FormField".constantize
    end 
  end
end
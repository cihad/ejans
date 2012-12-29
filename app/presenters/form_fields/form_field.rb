module FormFields
  class FormField < BasePresenter
    attr_reader :f

    presents :field

    def initialize(form_builder, *args)
      @f = form_builder
      super(*args)
    end

    delegate :label, :machine_name, :keyname, :required?, :hint, to: :field

    def form_key
      machine_name
    end

    def node
      @node ||= f.object
    end

    def value
      node.send(keyname)
    end

    def help
      content_tag :span, hint.html_safe, class: "help-block"
    end

    def partial_dir
      "custom_fields/fields/types/#{field.type}/form"
    end

    def to_s
      render partial_dir, field: self
    end

    def self.presenter(form_builder, field, template)
      "FormFields::#{field.type.classify}FormField".constantize.new(form_builder, field, template)
    end

    # def method_missing(*args, &block)
    #   @f.send(*args, &block)
    # rescue NoMethodError
    #   super
    # end
  end
end
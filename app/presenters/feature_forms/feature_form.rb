module FeatureForms
  class FeatureForm
    attr_reader :form_builder

    def initialize(form_builder, template)
      @form_builder = form_builder
      @template = template
    end

    def feature
      form_builder.object
    end

    def id
      feature.id
    end

    def conf
      @cont ||= feature.feature_configuration
    end

    def key_name
      conf.key_name
    end

    def form_key
      key_name
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
      @template.render "#{conf.partial_dir}/form", feature: self
    end

    def self.form_presenter_class(form_builder)
      ( 
        "FeatureForms::" +
        Features::Feature.to_feature(form_builder.object.class) +
        "FeatureForm"
      ).safe_constantize
    end 
  end
end
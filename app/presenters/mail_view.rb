class MailView

  def initialize(template)
    @template = template
    if block_given?
      yield self
    else
      self
    end
  end

  def template_dir
    "mail_template"
  end

  def layout(lyt)
    template_dir + "/" + lyt
  end

  %w[html head body mail_title content block block_title
  block_content footer].each do |method|
    define_method(method.to_sym) do |*args, &block|
      @template.render({partial: layout('blank_partial'), layout: layout(method)}, args, &block)
    end
  end  

  %w[block_title topbar footer].each do |method|
    define_method method.to_sym do |locals = {}|
      @template.render partial: layout(method), locals: locals
    end
  end

  def title(title = "")
    block_title title: title
  end
end
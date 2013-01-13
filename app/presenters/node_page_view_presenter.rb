class NodePageViewPresenter

  attr_reader :node, :node_type, :template

  def initialize(node, node_type, template)
    @node       = node
    @node_type  = node_type
    @template   = template
    yield self if block_given?
  end

  delegate :css, :js, :user_input_node_template, to: :node_view
  
  alias :h :template

  def wrapper
    %q{<div class='node'>
      <%= node %>
    </div>}
  end

  def rendered_css
    h.content_tag :style, css, type: Mime::CSS
  end

  def rendered_js
    h.javascript_tag js
  end

  def rendered_node
    NodeViewPresenter.new(node_view.node_template, node, node_type, @template).to_s.html_safe
  end

  def info
    h.render 'info'
  end

  def to_s
    h.render inline: wrapper, locals: { node: rendered_node }
  end

private

  def node_view
    @node_view ||= node_type.node_view
  end
end

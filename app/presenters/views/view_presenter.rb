module Views
  class ViewPresenter
    attr_accessor :view
    attr_reader :nodes, :node_type, :node_type_layout, :node_layout

    def initialize(params = {}, node_type, nodes, template)
      @params = params
      @template = template
      @node_type = node_type
      @nodes = nodes
    end

    def default_view
      node_type.views.first
    end

    def to_s
      @template.render(inline: node_type_layout, locals: { nodes: rendered_nodes })
    end

    def rendered_nodes
      conf_datas = node_type.conf_datas
      rendered = nodes.inject("") do |str, node|
        str << @template.render(inline: node_layout, locals: node.mapping(conf_datas))
      end.html_safe
      rendered
    end

    def css
      @template.content_tag :style, view.css, type: Mime::CSS
    end

    def js
      @template.javascript_tag view.js
    end
  end
end
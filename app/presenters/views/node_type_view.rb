module Views
  class NodeTypeView
    attr_reader :params, :node_type, :node_template, :field_data, :template, :nodes

    def initialize(params = {}, node_type, nodes, template)
      @params = params
      @template = template
      @node_type = node_type
      @field_data = node_type.field_data
      @nodes = nodes
    end

    def css
      template.content_tag :style, view.css, type: Mime::CSS
    end

    def js
      template.javascript_tag view.js
    end
  end
end
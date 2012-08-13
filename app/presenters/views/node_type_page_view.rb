module Views
  class NodeTypePageView < ViewPresenter
    def initialize
      super
      self.view = @params[:view_id]
      self.node_type_layout = view.node_type_layout
      self.node_layout = view.node_layout
    end

    def view=(view_id)
      @view = if view_id
                node_type.views.find(view_id)
              else
                default_view
              end
    end

    def node_type_layout=(layout)
      @node_type_layout = view.node_type_layout || ""
    end

    def node_layout=(layout)
      @node_layout = view.node_layout || ""
    end

    def default_view
      node_type.views.first
    end

    def to_s
      @template.render(inline: node_type_layout, locals: { nodes: rendered_nodes })
    end

    def rendered_nodes
      return nodes.inject("") do |str, node|
        str << Views::NodeView.new(node, node_layout, conf_data, @template)
      end.html_safe
    end

    def paginate
      @template.paginate nodes
    end

    def view_links
      params.delete(:node_id)
      if node_type.views.count > 1
        return node_type.views.inject("") do |output, v|
          current_class = "active" if v == view
          output += @template.link_to @template.url_for(params.merge(view_id: v.id.to_s)), class: "btn data-remote #{current_class}" do
            @template.content_tag :i, nil, class: "icon-th-large"
          end
          output
        end.html_safe
      end
    end
  end
end
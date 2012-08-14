module Views
  class CustomPageView < NodeTypeView
    attr_accessor :view, :node_layout

    def initialize(*args)
      super *args
      self.view = @params[:view_id]
      self.node_layout = view.node_layout
    end

    def node_layout=(node_layout)
      @node_layout = node_layout || ""
    end

    def view=(view_id)
      @view = if view_id
                node_type.views.find(view_id)
              else
                default_view
              end
    end

    def default_view
      node_type.views.first
    end

    def node_type_layout
      view.node_type_layout || ""
    end

    def to_s
      template.render(
        inline: node_type_layout,
        locals: { nodes: rendered_nodes })
    end

    def rendered_nodes
      nodes.inject("") do |str, node|
        str << NodeView.new(view, node_type, node, conf_data, template).to_s
      end.html_safe
    end


    def paginate
      @template.paginate nodes
    end

    def view_links
      params.delete(:node_id)
      if node_type.views.count > 1
        links = node_type.views.inject("") do |output, v|
                  current_class = "active" if v == view
                  output += @template.link_to @template.url_for(params.merge(view_id: v.id.to_s)), class: "btn data-remote #{current_class}" do
                    @template.content_tag :i, nil, class: "icon-th-large"
                  end
                  output
                end
        links.html_safe
      end
    end
  end
end
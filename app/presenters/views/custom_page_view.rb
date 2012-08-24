module Views
  class CustomPageView < NodeTypeView
    attr_accessor :view, :node_template

    def initialize(*args)
      super *args
      self.view = @params[:view_id]
      self.node_template = view.node_template
    end

    def node_template=(node_template)
      @node_template = node_template || ""
    end

    def view=(view_id)
      @view = if view_id
                node_type.views.find(view_id)
              else
                default_view
              end
    end

    def default_view
      nodes_index_views.first
    end

    def node_type_template
      view.node_type_template || ""
    end

    def to_s
      template.render(
        inline: node_type_template,
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

    def nodes_index_views
      node_type.views.reject { |view| view.class == Views::Node }
    end

    def view_links
      params.delete(:node_id)
      if nodes_index_views.count > 1
        links = nodes_index_views.inject("") do |output, v|
                  current_class = "active" if v == view
                  output += @template.link_to @template.url_for(params.merge(view_id: v.id.to_s)), class: "btn data-remote #{current_class}" do
                    @template.content_tag :i, nil, class: "icon-th-large"
                  end
                  output
                end
        links.html_safe
      end
    end

    def sort_links
      sort = params.delete(:sort)
      direction = params.delete(:direction)
      output = ""
      node_type.sort_data.each do |machine_name, label|
        dir, active_class = if sort == machine_name.to_s
                              [direction == "asc" ? "desc" : "asc", "active"]
                            else
                              ["asc",nil]
                            end

        icon = if sort == machine_name.to_s
                  direction == "asc" ? "icon-chevron-up" : "icon-chevron-down"
                else
                  nil
                end

        output += @template.link_to @template.url_for(params.merge(sort: machine_name, direction: dir)), class: "btn #{active_class}" do
            ("#{label}" + "<i class='#{icon}'></i>").html_safe
        end
      end
      output.html_safe
    end
  end
end
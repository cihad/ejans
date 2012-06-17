class ViewPresenter
  attr_accessor :params, :node_type, :current_view_param

  def initialize(params = {}, template)
    self.params = params
    @template = template
    self.node_type = NodeType.find(params.delete(:node_type_id))
    self.current_view_param = params[:view]
  end

  def current_view_param=(current_view_param)
    @current_view_param = current_view_param ? current_view_param.to_sym : default_view_type
  end

  # => "list"
  def default_view_type
    node_type.views.first.type
  end

  # => :list
  def current_view_type
    Views::View::VIEW_TYPES.include?(current_view_param) ? current_view_param : default_view_type
  end

  # => content_tag :ul, id: "nodes", &block
  def view_tag(&block)
    case current_view_type
    when :list
      @template.content_tag :ul, id: "nodes list-view", &block
    when :table
      @template.content_tag :table, id: "nodes", class: "table table-view", &block
    when :node
      @template.content_tag :div, class: "node node-view", &block
    when :grid
      @template.content_tag :div, class: "row nodes grid-view", &block
    else
      @template.content_tag :div, id: "nodes", &block
    end
  end

  # => 
  def view_links
    params.delete(:node_id)
    if node_type.views.count > 1
      links = node_type.views.inject("") do |output, view|
                unless view.type == :node
                  current_class = "active" if view.type == current_view_type
                  output += @template.link_to @template.url_for(params.merge(view: view.type)), class: "btn data-remote #{current_class}" do
                    @template.content_tag :i, nil, class: view_icon(view)
                  end
                  output
                end
              end
      links.html_safe if links
    end
  end

  # => "icon-th-list"
  def view_icon(view)
    case view.type.to_sym
    when :list
      "icon-list"  
    when :table
      "icon-th"
    when :node
      "icon-th-large"
    else
      "icon-th-large"
    end
  end
end
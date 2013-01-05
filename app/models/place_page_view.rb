class PlacePageView < NodeView
  def node_type_template
    self.class.node_type_template
  end

  def node_template
    if user_input_node_template.blank?
      %q{<p><%= (node_title + " ") * 10 %><br /></p>}
    else
      user_input_node_template
    end
  end

  def self.node_type_template
    %q{<div class="node">
        <div class="node-ins">
          <a href="<%= url %>" class="node-link" data-remote="true">
            <%= node %>
          </a>
        </div>
      </div>}
  end

  def self.place_page_template
    %q{<div class="row">
        <div id="place-nodes">
          <%= nodes %>
        </div>
      </div>}
  end
end
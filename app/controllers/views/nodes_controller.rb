module Views
  class NodesController < BaseController
    def edit
      @view = @node_type.node_view
    end

    def update
      @view = @node_type.node_view
      if @view.update_attributes(params[:views_node])
        redirect_to node_type_views_views_path(@node_type),
          notice: 'View was successfully updated.'
      else
        render action: "edit"
      end
    end
  end
end
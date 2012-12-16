module Views
  class NodesController < BaseController
    def edit
      @view = @node_type.node_view
    end

    def update
      @view = @node_type.node_view
      if @view.update_attributes(params[:views_node])
        redirect_to :back, notice: t('views.node.success_update')
      else
        render action: "edit"
      end
    end
  end
end
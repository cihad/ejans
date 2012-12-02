module Views
  class PlacePagesController < BaseController
    def edit
      @view = @node_type.place_page_view
    end

    def update
      @view = @node_type.place_page_view
      if @view.update_attributes(params[:views_place_page])
        redirect_to node_type_views_views_path(@node_type),
          notice: 'View was successfully updated.'
      else
        render action: "edit"
      end
    end
  end
end
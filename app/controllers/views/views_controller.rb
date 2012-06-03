module Views
  class ViewsController < ApplicationController
    before_filter :node_type

    def index
      @views = @node_type.views
    end

    def new
      @view = @node_type.views.build
      if Views::NodeViews::View::VIEW_TYPES.any? {|type| type.to_s == params[:type] }
        view = "views/node_views/#{params[:type].classify}_view".camelize.constantize
        @view.send("build_#{params[:type]}_view")
      else
        view = "views/node_views/list_view".camelize.constantize
        @view.send("build_list_view")
      end
    end

    private
    def node_type
      @node_type = NodeType.find(params[:node_type_id])
    end
  end
end
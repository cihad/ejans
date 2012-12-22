module Views
  class BaseController < ApplicationController
    before_filter :node_type
    
  private

    def node_type
      @node_type = NodeType.find(params[:node_type_id])
    end

    def current_resource
      @current_resource = node_type if params[:node_type_id]
    end

  end
end
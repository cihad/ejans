module Views
  class BaseController < ApplicationController
    before_filter :node_type, except: [:sort]
    
    private
    def node_type
      @node_type = NodeType.find(params[:node_type_id])
    end
  end
end
module Views
  class BaseController < ApplicationController
    before_filter :node_type, except: [:sort]
    before_filter :authenticate_user!
    before_filter :must_be_an_administrator
    
    private
    def node_type
      @node_type = NodeType.find(params[:node_type_id])
    end

    def must_be_an_administrator
      unless @node_type.administrators.include?(current_user)
        redirect_to node_type_nodes_path(@node_type),
                    alert: "Bunu goruntulemeye yetkilisi degilsiniz."
      end
    end
  end
end
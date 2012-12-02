class MarketingController < ApplicationController
  before_filter :node_type
  before_filter :authenticate_user!
  before_filter :must_be_an_administrator

  def new
    @marketing = Marketing.new
  end

  def create
    @marketing = @node_type.marketing.new(params[:marketing])
    if @marketing.save
      redirect_to @node_type, notice: "Sending email..."
    end
  end

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
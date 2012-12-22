class MarketingController < ApplicationController
  before_filter :node_type

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

  def current_resource
    @current_resource ||= node_type if params[:node_type_id]
  end
end
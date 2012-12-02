class MarketingTemplatesController < ApplicationController
  before_filter :node_type
  before_filter :authenticate_user!, except: [:show]
  before_filter :must_be_an_administrator, except: [:show]
  layout "mail", only: [:show]


  def index
    @marketing_templates = @node_type.marketing_templates
  end

  def show
    @marketing_template = @node_type.marketing_templates.find(params[:id])
  end

  def new
    @marketing_template = @node_type.marketing_templates.new(params)
  end

  def edit
    @marketing_template = @node_type.marketing_templates.find(params[:id])
  end

  def create
    @marketing_template = @node_type.marketing_templates.new(params[:marketing_template])
    if @marketing_template.save
      redirect_to node_type_marketing_template_path(@node_type, @marketing_template),
        notice: 'Marketing template was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @marketing_template = @node_type.marketing_templates.find(params[:id])
    if @marketing_template.update_attributes(params[:marketing_template])
      redirect_to node_type_marketing_template_path(@node_type, @marketing_template),
        notice: 'Marketing template was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @marketing_template = @node_type.marketing_templates.find(params[:id])
    if @marketing_template.destroy
      redirect_to node_type_marketing_templates_path(@node_type)
    else
      index
      render action: "index"
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
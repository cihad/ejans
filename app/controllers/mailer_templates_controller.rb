class MailerTemplatesController < ApplicationController
  before_filter :node_type

  before_filter :mailer_template, only: [:show, :edit, :update, :destroy]

  layout :set_layout

  def index
    @mailer_templates = @node_type.mailer_templates
  end

  def show
  end

  def new
    @mailer_template = @node_type.mailer_templates.new(params)
  end

  def edit
  end

  def create
    @mailer_template = @node_type.mailer_templates.new(params[:mailer_template])
    if @mailer_template.save
      redirect_to node_type_mailer_template_path(@node_type, @mailer_template)
    else
      render action: "new"
    end
  end

  def update
    if @mailer_template.update_attributes(params[:mailer_template])
      redirect_to node_type_mailer_template_path(@node_type, @mailer_template)
    else
      render action: "edit"
    end
  end

  def destroy
    if @mailer_template.destroy
      redirect_to node_type_mailer_templates_path(@node_type)
    else
      index
      render action: "index"
    end
  end

  private
  def node_type
    @node_type ||= NodeType.find(params[:node_type_id])
  end

  def mailer_template
    @mailer_template = @node_type.mailer_templates.find(params[:id])    
  end

  def current_resource
    @current_resource ||= node_type
  end

  def set_layout
    if params[:action] == "show"
      "mail"
    else
      "application"
    end
  end
end
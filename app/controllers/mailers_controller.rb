class MailersController < ApplicationController
  before_filter :node_type

  def new
    @mailer = Mailer.new
  end

  def create
    @mailer = @node_type.mailers.new(params[:mailer])
    if @mailer.save
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
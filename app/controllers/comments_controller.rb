class CommentsController < ApplicationController
  before_filter :node
  before_filter :node_type
  before_filter :comment, only: :destroy
  respond_to :js

  def create
    @comment = @node.comments.new(params[:comment].merge(author: current_user))
    if @comment.save
      respond_with @comment
    end
  end

  def destroy
    @comment.destroy
    render nothing: true
  end

  private

  def node_type
    @node_type = NodeType.find(params[:node_type_id])
  end

  def node
    @node = node_type.nodes.find(params[:node_id])
  end

  def comment
    @comment = node.comments.find(params[:id])
  end

  def current_resorce
    @current_resorce ||= comment if params[:id]
  end
end

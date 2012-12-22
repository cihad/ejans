class CommentsController < ApplicationController
  before_filter :node
  before_filter :comment, only: :destroy
  respond_to :js

  def create
    @comment = @node.comments.new(params[:comment])
    @comment.save
  end

  def destroy
    @comment.destroy
  end

  private

  def node
    @node ||= Node.find(params[:comment][:node_id])
  end

  def comment
    @comment ||= node.comments.find(params[:id])
  end

  def current_resorce
    @current_resorce ||= comment if params[:id]
  end
end

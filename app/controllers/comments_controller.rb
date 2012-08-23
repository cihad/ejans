class CommentsController < ApplicationController
  before_filter :node
  respond_to :js

  def create
    @comment = @node.comments.new(params[:comment])
    @comment.save
  end

  def destroy
    @comment = @node.comments.find(params[:id])
    @comment.destroy
  end

  private

  def node
    @node = Node.find(params[:comment][:node_id])
  end
end

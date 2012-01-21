class CommentsController < ApplicationController

  def create
    @comment = current_account.comments.new(params[:comment])

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        format.js
      else
        format.html { render action: "new" }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to comments_url }
    end
  end
end

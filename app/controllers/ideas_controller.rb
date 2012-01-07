class IdeasController < ApplicationController
  def create
    if account_signed_in?
      @idea = current_account.ideas.new(params[:idea])
    else
      @idea = Idea.new(params[:idea])
    end

    respond_to do |format|
      if @idea.save
        format.html { redirect_to services_path(:search => params[:idea][:search_string]), notice: 'Idea was successfully created.' }
        format.js
      end
    end
  end

  def destroy
    @idea = Idea.find(params[:id])
    @idea.destroy

    respond_to do |format|
      format.html { redirect_to ideas_url }
      format.json { head :ok }
    end
  end
end

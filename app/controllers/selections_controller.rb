class SelectionsController < ApplicationController
  before_filter :authenticate_account!

  def create
    @selection = Selection.new(params[:selection])
    @filter = @selection.filter

    respond_to do |format|
      if @selection.save
        format.html { redirect_to selections_service_path(@selection.service) }
        format.js
      end
    end
  end

  def destroy
    @selection = Selection.find(params[:id])
    service = @selection.filter.service
    respond_to do |format|
      if @selection.destroy
        format.html { redirect_to selections_service_path(service) }
        format.js
      end
    end
  end

  def multiple_add
    filter = Filter.find(params[:selection][:filter_id])
    params[:selection][:multiple_selections].split("\r\n").each do |label|
      selection = Selection.new(:label => label, :filter_id => filter.id)
      if selection.valid?
        selection.save
      end
    end
    redirect_to selections_service_path(filter.service)
  end
end
class ListItemsController < ApplicationController
  before_filter :feature_configuration

  def create
    @list_item = @fc.list_items.build(params[:features_list_item])
    respond_to do |format|
      if @list_item.save
        format.js
      end
    end
  end

  private
  def feature_configuration
    @fc = Features::FeatureConfiguration.find(params[:feature_configuration_id])
  end
end
class ListItemsController < ApplicationController
  # before_filter :feature_configuration

  def create
    @fc = Features::FeatureConfiguration.find(params[:feature_configuration_id])
    @list_item = @fc.child.list_items.build(params[:features_list_item])
    @list_item.save
    respond_to do |format|
      if @list_item.save
        format.js
      end
    end
    # render js: "console.log('#{@fc.child.list_items.count}')"
  end

  private
  def feature_configuration
    @fc = NodeType
            .find(params[:node_type_id])
            .feature_configurations
            .find(params[:feature_configuration_id])
  end
end
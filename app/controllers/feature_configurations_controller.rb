class FeatureConfigurationsController < ApplicationController
  before_filter :node_type
  include ControllerHelper

  def index
    @fcs = @node_type.feature_configurations
  end

  def show
    @fc = @node_type.feature_configurations.find(params[:id])
  end

  def new
    @fc = @node_type.feature_configurations.build(params[:features_feature_configuration])
  end

  def edit
    @fc = @node_type.feature_configurations.find(params[:id])
  end

  def create
    @fc = @node_type.feature_configurations.build(params[:features_feature_configuration])
    if @fc.save
      redirect_to @node_type,
        notice: 'Feature configuration was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @fc = @node_type.feature_configurations.find(params[:id])
    if @fc.update_attributes(params[:features_feature_configuration])
      redirect_to @node_type,
        notice: 'Feature configuration was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @fc = @node_type.feature_configurations.find(params[:id])
    @fc.destroy
    redirect_to @node_type
  end

  def sort
    sort_fields(params[:feature_configuration], Features::FeatureConfiguration)
  end

  private
  def node_type
    @node_type = NodeType.find(params[:node_type_id])
  end
end

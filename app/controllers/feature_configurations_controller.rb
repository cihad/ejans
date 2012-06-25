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
    if Features::Feature::FEATURE_TYPES.any? {|type| type == params[:type].to_sym }
      feature = "features/#{params[:type].classify}_feature_configuration".camelize.constantize
      @fc = @node_type.feature_configurations.build
      conf = @fc.send("build_#{params[:type]}_feature_configuration")
      if params[:type] == "list"
        3.times { conf.list_items.build }
      end
    else
      redirect_to :back, notice: "no feature"
    end
  end

  def edit
    @fc = @node_type.feature_configurations.find(params[:id])
    if @fc.feature_type == "list_feature"
      3.times { @fc.child.list_items.build }
    end
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
    # render js: "#{params[:features_feature_configuration]}"
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

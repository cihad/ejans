class FeatureConfigurationsController < ApplicationController
  before_filter :node_type
  before_filter :feature_param, only: [:create, :update]

  def index
    @fcs = @node_type.feature_configurations
  end

  def show
    @fc = @node_type.feature_configurations.find(params[:id])
  end

  def new
    if %w[integer string].any? {|type| type == params[:type] }
      feature = "features/#{params[:type].classify}_feature_configuration".camelize.constantize
      @fc = @node_type.feature_configurations.build
      @fc.send("build_#{params[:type]}_feature_configuration")
    else
      redirect_to :back, notice: "no feature"
    end
  end

  def edit
    @fc = @node_type.feature_configurations.find(params[:id])
  end

  def create
    @fc = @node_type.feature_configurations.build(@feature_param, @feature_class)
    # redirect_to @node_type, notice: @fc.inspect
    if @fc.save
      redirect_to @node_type,
        notice: 'Feature configuration was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @fc = @node_type.feature_configurations.find(params[:id])

    if @fc.update_attributes(@feature_param)
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

  private
  def node_type
    @node_type = NodeType.find(params[:node_type_id])
  end

  def feature_param
    @feature_class = "features/#{params[:type]}_feature_configuration"
              .camelize.constantize
    @feature_param = params[:"#{@feature_class.to_s.underscore.parameterize.underscore}"]
  end
end
class ViewsController < ApplicationController
  before_filter :node_type

  def index
    @views = @node_type.views
  end

  def new
    @view = @node_type.views.build
    if Views::View::VIEW_TYPES.any? {|type| type.to_s == params[:type] }
      # view = "views/#{params[:type].classify}_view".camelize.constantize
      @view.send("build_#{params[:type]}_view")
    else
      # view = "views/list_view".camelize.constantize
      @view.send("build_list_view")
    end
  end

  def create
    @view = @node_type.views.build(params[:views])
    render :inline => "<%= @view.feature_view %>"
  end

  def sort
    # TODO: LIKE THIS
    # params[:feature_configuration].each_with_index do |id, index|
    #   Features::FeatureConfiguration.find(id).update_attribute(:position, index+1)
    # end
    # render nothing: true
  end

  private
  def node_type
    @node_type = NodeType.find(params[:node_type_id])
  end
end
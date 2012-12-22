module CustomFields
  class FieldsController < ApplicationController
    before_filter :node_type

    include ControllerHelper

    layout "small"

    def index
      @fields = @node_type.nodes_custom_fields
    end

    def new
      @field = @node_type.nodes_custom_fields.build(params[:field])
    end

    def edit
      @field = @node_type.nodes_custom_fields.find(params[:id])
    end

    def create
      @field = @node_type.nodes_custom_fields.build(params[:field])
      if @field.save
        redirect_to node_type_custom_fields_fields_path(@node_type),
          notice: t('fields.messages.created')
      else
        render action: "new"
      end
    end

    def update
      @field = @node_type.nodes_custom_fields.find(params[:id])
      if @field.update_attributes(params[:field])
        redirect_to node_type_custom_fields_fields_path(@node_type),
          notice: 'Field configuration was successfully updated.'
      else
        render action: "edit"
      end
    end

    def destroy
      @field = @node_type.nodes_custom_fields.find(params[:id])
      if @field.destroy
        redirect_to node_type_custom_fields_fields_path(@node_type)
      else
        index
        render action: "index"
      end
    end

    def sort
      sort_fields(params[:field], @node_type.nodes_custom_fields)
    end
    
  private

    def node_type
      @node_type ||= NodeType.find(params[:node_type_id])
    end

    def current_resource
      @current_resource = node_type if params[:node_type_id]
    end
  end
end
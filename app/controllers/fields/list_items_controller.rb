module Fields
  class ListItemsController < ApplicationController
    include ControllerHelper
    before_filter :node_type, :field_configuration
    respond_to :js

    def create
      @list_item = @fc.list_items.build(params[:fields_list_item])
      if @list_item.save
        @fc.list_items << @list_item
      end
    end

    def destroy
      @list_item = Fields::ListItem.find(params[:id])
      @fc.delete_list_item(@list_item)
    end

    def sort
      sort_fields params[:fields_list_item], Fields::ListItem
      render nothing: true
    end

    private
    def node_type
      @node_type = NodeType.find(params[:node_type_id])
    end

    def field_configuration
      @fc = @node_type.field_configurations.find(params[:field_configuration_id])
    end
  end
end
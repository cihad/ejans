class ListItemsController < ApplicationController
  before_filter :field_configuration
  respond_to :js

  def create
    @list_item = @fc.list_items.build(params[:fields_list_item])
    @list_item.save
  end

  private
  def field_configuration
    @fc = Fields::FieldConfiguration.find(params[:field_configuration_id])
  end
end
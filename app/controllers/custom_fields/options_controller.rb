module CustomFields
  class OptionsController < ApplicationController
    include ControllerHelper
    before_filter :node_type, :field
    respond_to :js

    def create
      @option = @field.options.build(params[:fields_option])
      if @option.save
        @field.options << @optio
      end
    end

    def destroy
      @option = CustomFields::Fields::Select::Option.find(params[:id])
      @field.delete_option(@option)
    end

    def sort
      sort_fields params[:fields_option], CustomFields::Fields::Select::Option
      render nothing: true
    end

    private
    def node_type
      @node_type = NodeType.find(params[:node_type_id])
    end

    def field
      @field = @node_type.nodes_custom_fields.find(params[:field_id])
    end
  end
end
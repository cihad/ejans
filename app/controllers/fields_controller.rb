class FieldsController < ApplicationController
  include ControllerHelper
  
  def sort
    sort_fields params[:field_configuration], Fields::FieldConfiguration
  end
end
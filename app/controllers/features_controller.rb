class FeaturesController < ApplicationController
  include ControllerHelper
  
  def sort
    sort_fields params[:feature_configuration], Features::FeatureConfiguration
  end
end
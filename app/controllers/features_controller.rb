class FeaturesController < ApplicationController
  def sort
    params[:feature_configuration].each_with_index do |id, index|
      Features::FeatureConfiguration.find(id).update_attribute(:position, index+1)
    end
    render nothing: true
  end
end
class ErrorsController < ApplicationController
  layout "small"
  
  def not_found
    render :status => :not_found
  end
end

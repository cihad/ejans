class ApplicationController < ActionController::Base
  include LocationHelper
  include Ejans::Authorization

  protect_from_forgery
end

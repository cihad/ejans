module Admin
  class BaseController < ApplicationController
    load_and_authorize_resource
    layout "admin"
    
    def current_ability
      @current_ability ||= AdminAbility.new(current_account)
    end
  end
end
class Admin::DashboardController < ApplicationController
  
  def index
    
  end

  def notifications
    @notifications = Notification.where(:active => false)
  end
end
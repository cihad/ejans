module Admin
  class NotificationsController < BaseController
    load_and_authorize_resource
    
    def index
      @notifications = Notification.order("published ASC")
    end

    def publish
      @notification = Notification.find(params[:id])
      
      if @notification.update_attributes(:published => true, :published_at => Time.now)
        redirect_to admin_notifications_path, :notice => "Notification succesfully publish."
      else
        render action: "index"
      end
    end

  end
end
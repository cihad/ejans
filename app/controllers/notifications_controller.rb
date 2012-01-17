class NotificationsController < ApplicationController
  load_and_authorize_resource
  before_filter :service

  def show
    @notification = Notification.find(params[:id])

    if account_signed_in?
      if notice = current_account.notices.find_by_notification_id(params[:id])
        notice.update_attributes(:read => true, :new => false)
      end
    end
  end

  def new
    @notification = Notification.new(:service => @service)

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /notifications/1/edit
  def edit
    @notification = Notification.find(params[:id])
  end

  def create
    @notification = @service.notifications.new(params[:notification].merge(:notificationable => current_account))
    selection_ids = params[:notification][:selection_ids]
    @subscription_count = selection_ids

    respond_to do |format|
      if @notification.valid_filter? selection_ids
        if @notification.save
          format.html { redirect_to @service, notice: 'Notification was successfully created.' }
          format.json { render json: @notification, status: :created, location: @notification }
          format.js
        else
          format.html { render action: "new" }
          format.json { render json: @notification.errors, status: :unprocessable_entity }
          format.js
        end
      else
        flash.now[:alert] = 'Please select minumum a item from each filter.'
        format.html { render action: "new",  }
        format.js
      end
      # format.html { render action: "new" }
      # format.js
    end
  end

  def update
    @notification = Notification.find(params[:id])
    selection_ids = params[:notification][:selection_ids]

    respond_to do |format|
      if @notification.valid_filter? selection_ids
        if @notification.update_attributes(params[:notification])
          format.html { redirect_to [@service, @notification], notice: 'Notification was successfully updated.' }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @notification.errors, status: :unprocessable_entity }
        end
      else
        format.html { render action: "edit", alert: 'Please select minumum a item from each filter.' }
      end
    end
  end

  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy

    respond_to do |format|
      format.html { redirect_to @service }
      format.json { head :ok }
    end
  end

  def publish
    @notification = Notification.find(params[:id])
    if @notification.update_attributes(:published => true)
      redirect_to admin_dashboard_notifications_path, notice: "Notification was successfully published."
    else
      redirect_to admin_dashboard_notifications_path
    end
  end

  def calculate
    params[:selection_ids] = params[:selection_ids].split
    @subscription_price = @service.filters.blank? ? @service.subscriptions.count : Notification.new(:service => @service).subscription_price(params[:selection_ids])

    respond_to do |format|
      format.js
    end
  end

  def statistics
    @notification = Notification.find(params[:id])
  end

  private
    def service
      @service = Service.find(params[:service_id])
    end
end

class NotificationsController < ApplicationController
  load_and_authorize_resource
  before_filter :service

  def show
    @notification = Notification.find(params[:id])
    @comments = @notification.comments.where(parent_id: nil)

    if account_signed_in?
      if notice = current_account.notices.find_by_notification_id(params[:id])
        notice.update_attributes(:read => true, :new => false)
      end
    end
  end

  def new
    @notification = Notification.new
    @notification.services_notifications.build(service_id: @service.id)

    if params[:service_title].present?
      @notification = Notification.new
      @service = Service.find_by_title(params[:service_title])
      @notification.services_notifications.build(service_id: @service.id)
      @show = true
      respond_to { |format| format.js }
    end
  end

  def edit
    @notification = Notification.find(params[:id])
  end

  def create
    @notification = Notification.new(params[:notification].merge(:notificationable => current_account))

    if @notification.save
      redirect_to @service, notice: 'Notification was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @notification = Notification.find(params[:id])

    if @notification.update_attributes(params[:notification])
      redirect_to [@service, @notification], notice: 'Notification was successfully updated.'
    else
      render action: "edit"
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

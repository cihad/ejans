class NotificationsController < ApplicationController
  before_filter :service

  # GET /notifications/1
  # GET /notifications/1.json
  def show
    @notification = Notification.find(params[:id])

    if account_signed_in?
      if notice = current_account.notices.find_by_notification_id(params[:id])
        notice.update_attributes(:read => true, :new => false)
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @notification }
    end
  end

  # GET /notifications/new
  # GET /notifications/new.json
  def new
    @notification = Notification.new(:service => @service)

    respond_to do |format|
      format.html # new.html.erb
      format.js
    end
  end

  # GET /notifications/1/edit
  def edit
    @notification = Notification.find(params[:id])
  end

  # POST /notifications
  # POST /notifications.json
  def create
    @notification = @service.notifications.new(params[:notification])
    selection_ids = params[:notification][:selection_ids]
    @subscription_count = selection_ids

    respond_to do |format|
      if @notification.valid_filter? selection_ids
        if @notification.save
          format.html { redirect_to @service, notice: 'Notification was successfully created. #{selection_ids}' }
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

  # PUT /notifications/1
  # PUT /notifications/1.json
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

  # DELETE /notifications/1
  # DELETE /notifications/1.json
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
    @subscription_price = @service.filters.blank? ? @service.subscriptions.count : Notification.new(:service => @service).subcription_price(params[:selection_ids])

    respond_to do |format|
      format.js
    end
  end

  def statics
    @notification = Notification.find(params[:id])
  end

  private
    def service
      @service = Service.find(params[:service_id])
    end
end

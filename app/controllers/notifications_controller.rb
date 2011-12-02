class NotificationsController < ApplicationController
  before_filter :service

  # GET /notifications/1
  # GET /notifications/1.json
  def show
    @notification = Notification.find(params[:id])

    if notice = current_account.notices.find_by_notification_id(params[:id])
      notice.update_attributes(:read => true)
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @notification }
    end
  end

  # GET /notifications/new
  # GET /notifications/new.json
  def new
    @notification = Notification.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @notification }
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

    respond_to do |format|
      if @notification.save
        format.html { redirect_to @service, notice: 'Notification was successfully created.' }
        format.json { render json: @notification, status: :created, location: @notification }
      else
        format.html { render action: "new" }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /notifications/1
  # PUT /notifications/1.json
  def update
    @notification = Notification.find(params[:id])

    respond_to do |format|
      if @notification.update_attributes(params[:notification])
        format.html { redirect_to [@service, @notification], notice: 'Notification was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
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

  private
    def service
      @service = Service.find(params[:service_id])
    end
end

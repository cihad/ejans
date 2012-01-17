class NoticesController < ApplicationController
  before_filter :authenticate_account!

  def create
    @notification = Notification.find(params[:notice][:notification_id])
    @service = @notification.service
    if current_account.credit.credit >= @service.service_price.receiver_credit
      notice = current_account.subscription(@service).notices.new(:notification_id => @notification.id, :sufficient_credit => true)
      if notice.save
        respond_to do |format|
          format.html { redirect_to [@service, @notification] }
          format.js
        end
      end
    else
      @message = t('global.insufficient_credit')
      respond_to do |format|
        format.html { redirect_to [@service, @notification] }
        format.js
      end
    end
  end

end
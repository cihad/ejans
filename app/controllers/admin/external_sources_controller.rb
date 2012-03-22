module Admin
  class ExternalSourcesController < BaseController
    def index
      @external_sources = ExternalSource.where(view: false)
    end

    def new
      if @external_source = ExternalSource.where(view: false).last
        @external_source.update_attributes(view: true)
        @service = @external_source.google_alert_feed.service
        @notification = Notification.new(service: @service)
      else
        render "new"
      end
    end

    def destroy
      @external_sources = ExternalSource.find(params[:id])
      if @external_sources.destroy
        redirect_to admin_external_sources_path, notice: "Successfully"
      end
    end
  end

end
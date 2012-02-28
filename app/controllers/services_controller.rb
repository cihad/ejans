class ServicesController < ApplicationController
  load_and_authorize_resource

  def index
    @services = Service.search(params[:search]).page(params[:page]).per(20)
  end

  def show
    @service = Service.find(params[:id])

    # if @service.service_price.receiver_credit == 0
    #   @notifications = @service.notifications.published.page(params[:page])
    # else
    #   if account_signed_in? and current_account.subscribing?(@service)
    #     subscription = current_account.subscription(@service)
    #     selection_ids = subscription.selections.map(&:id)
    #     @notifications = @service.which_notifications(selection_ids)
    #   else
    #     @notifications = @service.notifications.unavailable.page(params[:page])
    #   end
    # end
    @notifications = @service.notifications.page(params[:page])
    @subscription = current_account.subscription(@service) if account_signed_in?
    @subscription ||= @service.subscriptions.build
  end

  def selections
    @service = Service.find(params[:id])
  end

  def new
    @service = Service.new
    @service.build_service_price

    Service::FILTER_COUNT.times do
      filter = @service.filters.build
      5.times { filter.selections.build }
    end
  end

  def edit
    @service = Service.find(params[:id])

    form_count = Service::FILTER_COUNT - (@service.filters.count)
    form_count.times do
      filter = @service.filters.build
      5.times { filter.selections.new }
    end
  end

  def create
    @service = Service.new(params[:service])

    if @service.save
      redirect_to selections_service_path(@service), notice: "Service was successfully created."
    else
      filters_count = Service::FILTER_COUNT - params["service"]["filters_attributes"].select { |k, v| v["name"].present? }.count
      filters_count.times do
        filter = @service.filters.build
        5.times { filter.selections.build }
      end
      render action: "new"
    end
  end

  def update
    @service = Service.find(params[:id])

    if @service.update_attributes(params[:service])
      redirect_to @service, notice: 'Service was successfully updated.'
    else
      form_count = 3 - (@service.filters.count)
        form_count.times do
          filter = @service.filters.build
          5.times { filter.selections.new }
        end
      render action: "edit"
    end
  end

  def destroy
    @service = Service.find(params[:id])
    @service.destroy
    redirect_to services_url
  end

  def sort
    params[:selection].each_with_index do |id, index|
      Selection.update_all({position: index+1}, {id: id})
    end
    render nothing: true
  end

  def create_new_selection
    @selection = Selection.new(params[:selection])

    @service = @selection.filter.service

    respond_to do |format|
      if @selection.save
        format.html { redirect_to selections_service_path(@selection.filter.service) }
        format.js
      end
    end
  end
end

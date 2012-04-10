class SubscriptionsController < ApplicationController
  load_and_authorize_resource

  def index
    @account = current_account
    @subscriptions = @account.subscriptions
  end

  def show
    @subscription = Subscription.find(params[:id])
  end

  def edit
    @account = current_account
    @subscriptions = @account.subscriptions
  end

  def create
    @account = current_account
    @subscription = Subscription.new(params[:subscription].merge(:account => @account))
    @service = @subscription.service
    selection_ids = params[:subscription][:selection_ids].compact.reject(&:blank?) unless params[:subscription][:selection_ids].nil?

    if @subscription.save
      redirect_to @service, notice: "Subscription was successfully created."
    else
      redirect_to @service, alert: 'Please select minumum a item from each filter.'
    end
  end

  def update
    @subscription = Subscription.find(params[:id])
    @service = @subscription.service
    selection_ids = params[:subscription][:selection_ids].compact.reject(&:blank?) unless params[:subscription][:selection_ids].nil?

    if selection_ids.blank? && @subscription.service.filters.count != 0
      @subscription.destroy
      redirect_to @service, alert: "Subscription was successfull destroyed. Please select minumum a item from each filter for be subscriber."
    else
      if @subscription.update_attributes(params[:subscription])
        redirect_to @service, notice: "Subscription was successfully updated."
      else
        redirect_to @service, alert: 'Please select minumum a item from each filter.'
      end
    end
  end

  def multiple_update
    @subscriptions = Subscription.update(params[:subscriptions].keys, params[:subscriptions].values).reject { |p| p.errors.empty? }
    if @subscriptions.empty?
      flash[:notice] = "Subscriptions updated"
      redirect_to subscriptions_path
    else
      render :action => "edit_individual"
    end
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @service = @subscription.service
    @subscription.destroy
    redirect_to subscriptions_path, notice: 'Subscription was successfully destroyed.'
  end
end

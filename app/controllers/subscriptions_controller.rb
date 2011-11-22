class SubscriptionsController < ApplicationController
  # GET /subscriptions
  # GET /subscriptions.json
  def index
    @account = current_account
    @subscriptions = @account.subscriptions

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subscriptions }
    end
  end

  # POST /subscriptions
  # POST /subscriptions.json
  def create
    @account = current_account
    @subscription = Subscription.new(params[:subscription].merge(:account => @account))
    @service = @subscription.service
    selection_ids = params[:subscription][:selection_ids]

    respond_to do |format|
      if selection_ids.nil?
        format.html { redirect_to @service, alert: 'Nothing selected. Please select one.' }
      else
        if @subscription.save
          format.html { redirect_to @service, notice: 'Subscription was successfully created.' }
          format.json { render json: @subscription, status: :created, location: @subscription }
        else
          format.html { render action: "new" }
          format.json { render json: @subscription.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /subscriptions/1
  # PUT /subscriptions/1.json
  def update
    @subscription = Subscription.find(params[:id])
    @service = @subscription.service
    selection_ids = params[:subscription][:selection_ids]

    respond_to do |format|
      if selection_ids.nil?
        @subscription.destroy
        format.html { redirect_to @service, notice: "Subscription was successfull destroyed. Select one for be subscriber." }
      else
        if @subscription.update_attributes(params[:subscription])
          format.html { redirect_to @service, notice: 'Subscription was successfully updated.' }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @subscription.errors, status: :unprocessable_entity }
        end
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

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.json
  def destroy
    @subscription = Subscription.find(params[:id])
    @service = @subscription.service
    @subscription.destroy


    respond_to do |format|
      format.html { redirect_to subscriptions_path, notice: 'Subscription was successfully destroyed.' }
      format.json { head :ok }
    end
  end
end

class ServicesController < ApplicationController
  # GET /services
  # GET /services.json
  def index
    @services = Service.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @services }
    end
  end

  # GET /services/1
  # GET /services/1.json
  def show
    @service = Service.find(params[:id])
    @subscription = current_account.subscriptions.find_by_service_id(@service) if account_signed_in?

    if !@subscription
      @subscription = @service.subscriptions.build
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @service }
    end
  end

  def selections
    @service = Service.find(params[:id])
  end

  # GET /services/new
  # GET /services/new.json
  def new
    @service = Service.new
    @service.build_service_price

    3.times do
      filter = @service.filters.build
      5.times { filter.selections.build }
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @service }
    end
  end

  # GET /services/1/edit
  def edit
    @service = Service.find(params[:id])

    form_count = 3 - (@service.filters.count)
    form_count.times do
      filter = @service.filters.build
      5.times { filter.selections.new }
    end
  end

  # POST /services
  # POST /services.json
  def create
    @service = Service.new(params[:service])

    respond_to do |format|
      if @service.save
        format.html { redirect_to @service, notice: "Service was successfully created. #{params[:service]}" }
        format.json { render json: @service, status: :created, location: @service }
      else
        3.times do
          filter = @service.filters.build
          5.times { filter.selections.build }
        end
        format.html { render action: "new" }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /services/1
  # PUT /services/1.json
  def update
    @service = Service.find(params[:id])

    respond_to do |format|
      if @service.update_attributes(params[:service])
        format.html { redirect_to @service, notice: 'Service was successfully updated.' }
        format.json { head :ok }
      else
        form_count = 3 - (@service.filters.count)
          form_count.times do
            filter = @service.filters.build
            5.times { filter.selections.new }
          end
        format.html { render action: "edit" }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.json
  def destroy
    @service = Service.find(params[:id])
    @service.destroy

    respond_to do |format|
      format.html { redirect_to services_url }
      format.json { head :ok }
    end
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

class Admin::PaymentTypesController < ApplicationController
  # GET /payment_types
  # GET /payment_types.json
  def index
    @payment_types = PaymentType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @payment_types }
    end
  end

  # GET /payment_types/1
  # GET /payment_types/1.json
  def show
    @payment_type = PaymentType.find(params[:id])
    @payment_type.payment_type_selections.build

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @payment_type }
    end
  end

  # GET /payment_types/new
  # GET /payment_types/new.json
  def new
    @payment_type = PaymentType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @payment_type }
    end
  end

  # POST /payment_types
  # POST /payment_types.json
  def create
    @payment_type = PaymentType.new(params[:payment_type])

    respond_to do |format|
      if @payment_type.save
        format.html { redirect_to [:admin, @payment_type], notice: 'Payment type was successfully created.' }
        format.json { render json: @payment_type, status: :created, location: @payment_type }
      else
        format.html { render action: "new" }
        format.json { render json: @payment_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @payment_type = PaymentType.find(params[:id])
  end

  def update
    @payment_type = PaymentType.find(params[:id])
    
    if @payment_type.update_attributes(params[:payment_type])
      redirect_to [:admin, @payment_type], :notice => "Payment Type succesfully update."
    else
      render action: "edit"
    end
  end

  
end

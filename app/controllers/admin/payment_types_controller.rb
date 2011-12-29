module Admin
  class PaymentTypesController < BaseController
    load_and_authorize_resource

    def index
      @payment_types = PaymentType.all
    end


    def show
      @payment_type = PaymentType.find(params[:id])
      @payment_type.payment_type_selections.build
    end

    def new
      @payment_type = PaymentType.new
    end

    def edit
      @payment_type = PaymentType.find(params[:id])
    end

    def create
      @payment_type = PaymentType.new(params[:payment_type])

      if @payment_type.save
        redirect_to [:admin, @payment_type], notice: 'Payment type was successfully created.'
      else
        render action: "new"
      end
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
end
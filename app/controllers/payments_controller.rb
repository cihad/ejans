class PaymentsController < ApplicationController
  include ActionView::Helpers::NumberHelper

  def index
  end

  def new
    if params[:selection]
      @credit = current_account.credit
    end
  end

  def create
    payment_type_selection = PaymentTypeSelection.find(params[:payment_type_selection].to_i)

    credit = payment_type_selection.credit
    price = payment_type_selection.price
    payment_type = payment_type_selection.payment_type


    if current_account.credit.increment!(:credit, credit)
      credit_history = current_account.credit.credit_histories.build(
        :credit_datable => payment_type,
        :credit_quantity => credit,
        :price => price)

      if credit_history.save
        redirect_to subscriptions_path, notice: "Added #{credit} credits your account."
      else
        action :new
      end

    end
  end

  def history
  end

end

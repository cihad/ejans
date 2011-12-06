class PaymentsController < ApplicationController

  def index
  end

  def new
    @order = AccountCredit.new
  end

  def create
    credit = current_account.account_credit.credit.to_i + params[:account_credit][:credit].to_i
    @order = current_account.account_credit.update_attributes(:account => current_account, :credit => credit)

    respond_to do |format|
      if @order
        format.html { redirect_to payments_path, notice: "Added credit to your account." }
      else
        format.html { render action: "new" }
      end
    end
  end
end

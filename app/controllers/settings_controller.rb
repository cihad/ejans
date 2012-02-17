class SettingsController < ApplicationController
  def email
    @account = current_account
  end

  def password
    @account = current_account
  end

  def terminate
  end

  def update_email
    if params[:account].present?
      @account = Account.find(current_account.id)
      if @account.update_attributes(params[:account])
        # Sign in the account by passing validation in case his password changed
        sign_in @account, :bypass => true
        redirect_to subscriptions_path, notice: "Successfully."
      else
        render "email"
      end
    else
      @account = current_account
    end
  end

  def update_password
    @account = Account.find(current_account.id)
    if @account.update_attributes(params[:account])
      # Sign in the account by passing validation in case his password changed
      sign_in @account, :bypass => true
      redirect_to subscriptions_path, notice: "Your password changed."
    else
      render "password"
    end
  end
end

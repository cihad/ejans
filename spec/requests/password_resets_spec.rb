require 'spec_helper'

describe "PasswordResets" do
  it "email istediginde yeni parola gonderlemi" do
    account = FactoryGirl.create(:account)
    visit new_account_session_path
    click_link "Forgot your password?"
    fill_in "Email", with: account.email
    click_button "Send me reset password instructions"
  end
end

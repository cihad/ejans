require 'spec_helper'

describe "PasswordResets" do
  it "email istediginde yeni parola gondermeli" do
    account = FactoryGirl.create(:account)
    visit new_account_session_path
    click_link I18n.t('devise.passwords.new_password')
    fill_in "Email", with: account.email
    click_button I18n.t('devise.passwords.send_new')
    current_path.should eq(new_account_session_path)
    page.should have_content I18n.t('devise.passwords.send_instructions')
    last_email.to.should include(account.email)
  end
end

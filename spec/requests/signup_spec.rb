require 'spec_helper'

describe "Signup" do
  def try_signup(attrs = {})
    email                 = attrs[:email] || "valid_email@example.com"
    password              = attrs[:password] || "123456"
    password_confirmation = attrs[:password_confirmation] || "123456"

    visit signup_path
    within "#new_user" do
      fill_in "user_email",                 with: email
      fill_in "user_password",              with: password
      fill_in "user_password_confirmation", with: password_confirmation
      click_button t('users.signup')
    end
  end

  it "signup with correct information" do
    try_signup
    page.should have_content t('devise.registrations.signed_up_but_unconfirmed')
  end

  it "not signup with unvalid email" do
    try_signup(email: "unvalid@email")
    page.should_not have_content t('sessions.signout')
  end

  it "not signup with unvalid password_confirmation" do
    try_signup(password_confirmation: "unvalid_confirmation")
    page.should_not have_content t('sessions.signout')
  end
end
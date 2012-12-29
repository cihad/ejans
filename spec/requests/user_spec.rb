require 'spec_helper'

describe User do

  describe "sessions" do
    context "#confirm!" do
      let(:unconfirmed_user) { Fabricate(:unconfirmed_user) }

      it "not confirmed user doesnt sign" do
        visit signin_path
        fill_in I18n.t('sessions.email'), with: unconfirmed_user.email
        fill_in I18n.t('sessions.password'), with: "123456"
        click_button I18n.t('sessions.signin')
        page.should_not have_content t('devise.sessions.signed_in')
        page.should have_content t('devise.failure.unconfirmed')
      end

      it "confirmed user do sign" do
        unconfirmed_user.confirm!
        visit signin_path
        fill_in I18n.t('sessions.email'), with: unconfirmed_user.email
        fill_in I18n.t('sessions.password'), with: "123456"
        click_button I18n.t('sessions.signin')
        page.should have_content t('devise.sessions.signed_in')
        page.should_not have_content t('devise.failure.unconfirmed')
      end
    end

    describe "when correct information" do
      let(:user) { Fabricate(:user) }

      it "sign in" do
        signin user
        page.should have_content t('devise.sessions.signed_in')
        page.should have_content t('sessions.signout')
      end

      it "signout" do
        signin user
        signout user
        page.should_not have_content t('sessions.signout')
        page.should have_content t('devise.sessions.signed_out')
      end
    end

    describe "when incorrect information" do
      let(:user) { Fabricate(:user) }

      it "doesnt signin with unvalid email" do
        signin_with "incorrect_email@example.com"
        page.should_not have_content t('sessions.signout')
        page.should_not have_content t('sessions.signed_in')
      end

      it "doesnt signin with valid email and unvalid password" do
        signin_with user.email, "unvalid_password"
        page.should_not have_content t('sessions.signout')
        page.should_not have_content t('sessions.signed_in')
      end
    end
  end

  describe "registrations", js: true do
    it "new" do
      visit signup_path
      fill_in "user_email",                 with: "valid@email.com"
      fill_in "user_password",              with: "a_password"
      fill_in "user_password_confirmation", with: "a_password"
      click_button t('users.signup')
      page.should have_content t('devise.registrations.signed_up_but_unconfirmed')
    end

    it "edit" do
      user = Fabricate(:user, password: "123456")
      signin user
      visit edit_user_path
      fill_in "user_email",                 with: "a_valid_email@example.com"
      fill_in "user_password",              with: "654321"
      fill_in "user_password_confirmation", with: "654321"
      fill_in "user_current_password",      with: "123456"
      click_button t('actions.update')
    end
  end

  describe "passwords" do
    
  end

  describe "confirmations" do
    it "does confirm" do
      user = Fabricate(:unconfirmed_user)
      visit user_confirmation_path(:confirmation_token => user.confirmation_token)
      page.should have_content t('devise.confirmations.confirmed')
    end

    it "doesnt confirm" do
      user = Fabricate(:unconfirmed_user)
      visit user_confirmation_path(:confirmation_token => "thisisaunvalidconfirmationtoken")
      page.should_not have_content t('devise.confirmations.confirmed')
      within "legend" do
        page.should have_content t('devise.confirmations.resend')
      end
    end
  end
end
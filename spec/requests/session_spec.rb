require 'spec_helper'

describe "Session" do
  let(:user) { Fabricate(:user) }

  describe "when correct information" do
    it "signin with email" do
      signin_with user.email
      page.should have_content t('sessions.signout')
    end

    it "signin with username" do
      signin_with user.username
      page.should have_content t('sessions.signout')
    end

    it "signout" do
      signin_with user.email
      signout user
      page.should_not have_content t('sessions.signout')
    end
  end

  describe "when incorrect information" do
    after do
      page.should_not have_content t('sessions.signout')
      page.should have_content t('sessions.invalid_information')
    end

    it "not signin with unvalid email" do
      signin_with "incorrect_email@example.com"
    end

    it "not signin with unvalid username" do
      signin_with "incorrectusername"
    end

    it "not signin with valid email and unvalid password" do
      signin_with user.email, "unvalid_password"
    end
  end
end

require 'spec_helper'

describe User do
  let(:user) { Fabricate(:user) }

  describe "authorization" do
    it "cant edit" do
      visit edit_user_path(user)
      current_path.should_not eq edit_user_path(user)
      page.should have_content t('errors.not_authorized')
    end

    it "can edit self" do
      signin user
      visit user_path(user)
      current_path.should eq user_path(user)

      visit edit_user_path(user)
      current_path.should eq edit_user_path(user)
      page.should_not have_content t('errors.not_authorized')
    end

    it "can update self" do
      signin user

      visit edit_user_path(user)
      fill_in t('users.username'), with: "a_different_username"
      click_button t('actions.save')

      visit root_path
      page.should have_content "a_different_username"
    end

    it "admin edit any user" do
      user.make_admin!

      signin user
      visit user_path(user)
      current_path.should eq user_path(user)

      visit edit_user_path(user)
      current_path.should eq edit_user_path(user)
      page.should_not have_content t('errors.not_authorized')
    end
  end
end 
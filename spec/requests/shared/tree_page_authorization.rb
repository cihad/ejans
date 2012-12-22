shared_examples "tree" do
  describe "index page authorization" do
    it "as anonymous" do
      visit path
      current_path.should_not eq(path)
      page.should have_content t('errors.not_authorized')
    end

    it "as registered" do
      user = Fabricate(:user)
      user.make_registered!
      signin user
      visit path
      current_path.should_not eq(path)
      page.should have_content t('errors.not_authorized')
    end

    it "as admin" do
      admin = Fabricate(:user)
      admin.make_admin!
      signin admin
      visit path 
      current_path.should eq(path)
      page.should_not have_content t('errors.not_authorized')
    end
  end
end
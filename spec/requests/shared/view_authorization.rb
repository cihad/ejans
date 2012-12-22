shared_examples "view authorization" do
  describe "authorization" do
    it "as anonymous" do
      visit path
      current_path.should_not eq path
      page.should have_content t('errors.not_authorized')
    end

    it "as registered" do
      user = Fabricate(:user)
      user.make_registered!
      signin user
      visit path
      current_path.should_not be path
      page.should have_content t('errors.not_authorized')
    end

    it "as administrator" do
      user = Fabricate(:user)
      user.make_registered!
      
      node_type.administrators << user
      signin user
      visit path
      current_path.should_not be path
      page.should have_content t('errors.not_authorized')
    end

    it "as super administrator" do
      signin super_administrator
      visit path
      current_path.should eq path
      page.should_not have_content t('errors.not_authorized')
    end

    it "as admin" do  
      super_administrator.make_admin! unless super_administrator.admin?
      signin super_administrator
      visit path
      current_path.should eq path
      page.should_not have_content t('errors.not_authorized')
    end
  end
end
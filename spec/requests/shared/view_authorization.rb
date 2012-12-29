shared_examples "view authorization" do
  describe "authorization" do
    it "as anonymous" do
      visit path
      current_path.should_not eq path
      page.should have_content t('errors.not_authorized')
    end

    it "as registered" do
      user = Fabricate(:user)
      signin user
      visit path
      current_path.should_not eq path
      page.should have_content t('errors.not_authorized')
    end

    it "as administrator", js: true do
      user = Fabricate(:user)
      
      node_type.administrators << user
      signin user
      visit path
      current_path.should eq path
      page.should_not have_content t('errors.not_authorized')
    end

    it "as super administrator" do
      signin super_administrator
      visit path
      current_path.should eq path
      page.should_not have_content t('errors.not_authorized')
    end

    it "as admin" do  
      super_administrator.admin!
      signin super_administrator
      visit path
      current_path.should eq path
      page.should_not have_content t('errors.not_authorized')
    end
  end
end
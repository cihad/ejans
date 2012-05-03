require 'spec_helper'

describe "Home" do
  
  subject { pages }

  describe "Home page" do 
    before { visit root_path }
    it "should have the content 'Home'" do
      page.should have_selector 'title', text: I18n.t('home.index.title')
    end
  end
end
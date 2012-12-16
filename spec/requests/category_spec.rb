require 'spec_helper'

describe Category do
  describe "index page authorization" do
    specify do
      visit categories_path
      current_path.should_not eq(categories_path)
    end
  end
  
  describe "adds a category", js: true do
    let(:user) { Fabricate(:user) }

    before do
      user.make_admin!
      signin user
      visit categories_path
    end
    
    specify do
      click_link t('categories.add_category')
      categories = 3.times.inject([]) { |arr, _| arr << Faker::Lorem.word.capitalize }

      within("#new_category") do
        fill_in t('categories.name'), with: "A Category"
        fill_in t('categories.children'), with: categories.join("\n")
        click_button t('actions.save')
      end

      page.should have_content "A Category"
      click_link "A Category"

      page.should have_selector "ul li ul li"

      categories.each do |category|
        page.should have_link category
        list = all('.items li .category').find { |list| list.text == category }
        list.find('.controls a.add-child-items').click
        find('.uneditable-input').text.should eq "A Category"
        find_field(t 'categories.name').value.should eq category
        find('.btn-close').click
      end
    end
  end
end
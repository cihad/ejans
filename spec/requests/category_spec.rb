require 'spec_helper'
require 'requests/shared/tree_page_authorization'

describe Category do
  it_behaves_like "tree" do
    let(:path) { categories_path }
  end
  
  describe "adds a category", js: true do
    let(:user) { Fabricate(:admin) }

    before do
      signin user
      visit categories_path
    end
    
    specify do
      click_link t('categories.add_category')
      categories = 3.times.inject([]) { |arr, _| arr << Faker::Lorem.word.capitalize }

      binding.pry

      within("#new_category") do
        fill_in "category_name", with: "A Category"
        fill_in "category_child_nodes", with: categories.join("\n")
        click_button t('helpers.submit.create')
      end

      page.should have_content "A Category"
      click_link "A Category"

      page.should have_selector "ul li ul li"

      categories.each do |category|
        page.should have_link category
        list = all('.nodes li .category').find { |list| list.text == category }
        list.find('.controls a.add-child-nodes').click
        find('.uneditable-input').text.should eq "A Category"
        find_field(t 'simple_form.labels.category.name').value.should eq category
        find('.btn-close').click
      end
    end
  end
end
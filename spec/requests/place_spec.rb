require 'spec_helper'
require 'requests/shared/tree_page_authorization'

describe Place do
  it_behaves_like "tree"  do
    let(:path) { places_path }
  end
  
  describe "adds a place" do
    let(:admin) { Fabricate(:admin) }
    let(:place_attributes) { valid_attrinutes_for :place }

    before do
      signin admin
      visit places_path
    end

    specify do
      current_path.should eq(places_path)
    end

    specify js: true do
      click_link t('places.add_place')
      countries = 3.times.inject([]) { |arr, _| arr << Faker::Address.country }

      within("#new_place") do
        fill_in "place_name", with: "World"
        fill_in "place_child_nodes", with: countries.join("\n")
        click_button t('helpers.submit.create')
      end

      page.should have_content "World"
      click_link "World"

      page.should have_selector "ul li ul li"

      countries.each do |country|
        page.should have_link country
        find('li .place', text: country).find('.add-child-items').click
        find('.uneditable-input').text.should eq "World"
        find_field(t 'simple_form.labels.place.name').value.should eq country
        find('.btn-close').click
      end
    end
  end
end
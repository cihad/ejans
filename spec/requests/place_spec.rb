require 'spec_helper'

describe Place do
  describe "index page authorization" do
    specify do
      visit places_path
      current_path.should_not eq(places_path)
    end
  end
  
  describe "adds a place", js: true do
    let(:user) { Fabricate(:user) }
    let(:place_attributes) { valid_attrinutes_for :place }

    before do
      user.make_admin!
      signin user
      visit places_path
    end

    specify js: false do
      current_path.should eq(places_path)
    end

    specify do
      click_link t('places.add_place')
      countries = 3.times.inject([]) { |arr, _| arr << Faker::Address.country }

      within("#new_place") do
        fill_in t('places.name'), with: "World"
        fill_in t('places.children'), with: countries.join("\n")
        click_button t('actions.save')
      end

      page.should have_content "World"
      click_link "World"

      page.should have_selector "ul li ul li"

      countries.each do |country|
        page.should have_link country
        find('li .place', text: country).find('.add-child-items').click
        find('.uneditable-input').text.should eq "World"
        find_field(t 'places.name').value.should eq country
        find('.btn-close').click
      end
    end
  end
end
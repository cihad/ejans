require 'spec_helper'
require 'requests/shared/view_authorization'

describe NodeTypeView do
  let(:node_type) { Fabricate(:full_featured_node_type) }
  let(:super_administrator) { node_type.super_administrator }

  it_behaves_like "view authorization" do
    let(:path) { node_type_node_type_views_path(node_type) }
  end

  it "adds a custom view" do
    signin super_administrator

    visit new_node_type_node_type_view_path(node_type)

    fill_in "node_type_view_user_input_node_type_template",
      with: custom_view_node_type_template

    fill_in "node_type_view_user_input_node_template",
      with: custom_view_node_template(node_type)
      
    click_button t('helpers.submit.create')

    visit node_type_node_type_views_path(node_type)

    page.should have_selector(".sortable tbody tr")
  end

  it "deletes the custom view", js: true do
    signin super_administrator

    view = make_custom_view(node_type)

    visit node_type_node_type_views_path(node_type)

    within("#node_type_view_#{view.id}") do
      click_link t('actions.destroy')
    end

    alert.accept

    visit node_type_node_type_views_path(node_type)

    page.should_not have_select("#node_type_view_#{view.id}")
  end
end
require 'spec_helper'
require 'requests/shared/view_authorization'

describe Views::Custom do
  let(:node_type) { Fabricate(:full_featured_node_type) }
  let(:super_administrator) { node_type.super_administrator }

  def create_a_custom_view
    visit node_type_views_views_path(node_type)
    select "Custom", from: "_type"
    click_button t('views.new')

    # within ".tabbable" do click_link "Node Type" end
    # page.execute_script("$('#views_custom_user_input_node_type_template').show()")
    fill_in "views_custom_user_input_node_type_template", with: custom_view_node_type_template

    # within ".tabbable" do click_link "Node" end
    # page.execute_script("$('#views_custom_user_input_node_template').show()")
    fill_in "views_custom_user_input_node_template", with: custom_view_node_template(node_type)
    binding.pry
    click_button t('helpers.submit.create')
  end

  it_behaves_like "view authorization" do
    let(:path) { node_type_views_views_path(node_type) }
  end

  it "adds a custom view" do
    signin super_administrator

    create_a_custom_view

    visit node_type_views_views_path(node_type)
    page.should have_content("Views/Custom")
  end

  it "deletes the custom view", js: true do
    signin super_administrator

    view = make_custom_view(node_type)
    visit node_type_views_views_path(node_type)
    within("#view_#{view.id}") do
      click_link t('actions.destroy')
    end
    alert.accept
    visit node_type_views_views_path(node_type)
    page.should_not have_content("Views/Custom")
  end
end
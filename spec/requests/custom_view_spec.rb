require 'spec_helper'
require 'requests/shared/view_authorization'

describe Views::Custom do
  let(:node_type) { Fabricate(:full_featured_node_type) }
  let(:super_administrator) { node_type.super_administrator }

  def create_a_custom_view
    visit node_type_views_views_path(node_type)
    select "Custom", from: "_type"
    click_button t('views.add_new_view')
    page.execute_script("$('#views_custom_user_input_node_type_template').show()")
    fill_in "views_custom_user_input_node_type_template", with: custom_view_node_type_template
    page.execute_script("$('#views_custom_user_input_node_template').show()")
    fill_in "views_custom_user_input_node_template", with: custom_view_node_template(node_type)
    click_button t('views.save')
  end

  it_behaves_like "view authorization" do
    let(:path) { node_type_views_views_path(node_type) }
  end

  describe "adds a custom view", js: true do
    before do
      signin super_administrator
    end

    specify do
      create_a_custom_view
      visit node_type_views_views_path(node_type)
      page.should have_content("Views/Custom")
    end
  end

  describe "deletes the custom view", js: true do
    before do
      signin super_administrator
    end

    specify do
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
end
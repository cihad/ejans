require 'spec_helper'

describe Views::Custom do
  let(:node_type) { Fabricate(:full_featured_node_type) }
  let(:administrator) { node_type.administrators.first }

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

  before do
    signin administrator
    create_a_custom_view
    visit node_type_views_views_path(node_type)
  end

  describe "adds a custom view", js: true do
    specify do
      page.should have_content("Views/Custom")
    end
  end

  describe "deletes the custom view", js: true do
    specify do
      click_link t('actions.destroy')
      page.driver.browser.switch_to.alert.accept
      visit node_type_views_views_path(node_type)
      page.should_not have_content("Views/Custom")
    end
  end
end
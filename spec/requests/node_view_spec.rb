require 'spec_helper'

describe "NodeView" do
  describe "adds a node view", js: true do
    let(:node_type) { Fabricate(:full_featured_node_type) }
    let(:administrator) { node_type.administrators.first }

    specify do
      signin administrator
      visit node_type_path(node_type)
      click_link t('views.views')
      click_link t('views.edit_node_view')
      page.execute_script("$('#views_node_user_input_node_template').show()")
      fill_in "views_node_user_input_node_template", with: user_input_node_template(node_type)
      click_button t('views.save')
    end
  end
end
require 'spec_helper'

describe "NodeView" do
  let(:node_type) { Fabricate(:full_featured_node_type) }
  let(:administrator) { node_type.administrators.first }

  before do
    signin administrator
  end
  
  describe "adds a node view", js: true do
    specify do
      visit node_type_path(node_type)
      click_link t('views.views')
      click_link t('views.edit_node_view')
      page.execute_script("$('#views_node_user_input_node_template').show()")
      fill_in "views_node_user_input_node_template",
        with: user_input_node_template(node_type)
      click_button t('views.save')
    end
  end

  describe "fills a sample view", js: true do
    specify do
      visit edit_node_type_views_node_path(node_type)
      click_on t('views.node.fill_a_sample_view')
      alert.accept
      page.should have_content t('views.node.success_update')
      find("#views_node_user_input_node_template").value.
        should eq(TableViewNodeTemplate.new(node_type).to_s)
    end
  end
end
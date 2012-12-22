require 'spec_helper'
require 'requests/shared/view_authorization'

describe "NodeView" do
  let(:node_type) { Fabricate(:full_featured_node_type) }
  let(:super_administrator) { node_type.super_administrator }

  it_behaves_like "view authorization" do
    let(:path) { edit_node_type_views_node_path(node_type) }
  end
  
  describe "adds a node view", js: true do
    before do
      signin super_administrator
    end

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
    before do
      signin super_administrator
    end
    
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
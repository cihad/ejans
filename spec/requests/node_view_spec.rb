require 'spec_helper'
require 'requests/shared/view_authorization'

describe NodeView do
  let(:node_type) { Fabricate(:full_featured_node_type) }
  let(:super_administrator) { node_type.super_administrator }

  it_behaves_like "view authorization" do
    let(:path) { edit_node_type_node_view_path(node_type) }
  end
  
  it "adds a node view" do
    signin super_administrator

    visit edit_node_type_node_view_path(node_type)

    fill_in "node_view_user_input_node_template",
      with: user_input_node_template(node_type)

    click_button t('helpers.submit.update')
  end

  it "fills a sample view" do
    signin super_administrator

    visit edit_node_type_node_view_path(node_type)

    click_on t('node_views.fill_a_sample_view')

    page.should have_content t('node_views.success_update')

    find("#node_view_user_input_node_template").
      value.
      should == TableViewNodeTemplate.new(node_type).to_s
  end
end
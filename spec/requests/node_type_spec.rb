require 'spec_helper'

describe "NodeType" do
  it "not be creatable by registered user" do
    user = Fabricate(:user)
    signin user
    visit new_node_type_path
    current_path.should_not == new_node_type_path
    current_path.should == root_path
  end

  it "be creatable by admin " do
    admin = Fabricate(:admin)
    signin admin
    visit new_node_type_path
    current_path.should == new_node_type_path
  end

  it "creates new node type" do
    admin = Fabricate(:admin)
    attributes = valid_attributes_for(:node_type)

    signin admin
    
    visit new_node_type_path

    expect {
      fill_in 'node_type_name', with: attributes[:name]
      fill_in 'node_type_title_label', with: attributes[:title_label]
      fill_in 'node_type_description', with: attributes[:description]
      choose "node_type_filters_position_#{attributes[:filters_position]}"
      fill_in 'node_type_node_expiration_day_limit', with: attributes[:node_expiration_day_limit]
      checkbox 'node_type_commentable', attributes[:commentable]
      checkbox 'node_type_signin_required', attributes[:signin_required]
      attach_file 'node_type_background_image', "#{Rails.root}/spec/support/images/wood_background.jpg"
      click_button t('helpers.submit.create')
    }.to change(NodeType, :count).by(1)


    page.should have_content t('node_types.dashboard')
    page.should have_content t('node_types.configurations')
    page.should have_content t('fields.fields')
    page.should have_content t('node_type_views.views')
    page.should have_content t('mailers.mailer')
    page.should have_content t('nodes.nodes')

    visit node_types_path
    page.should have_link attributes[:name]
  end

  it "#destroy", js: true do
    node_type = Fabricate(:full_featured_node_type)
    super_administrator = node_type.super_administrator

    signin super_administrator
    visit node_type_path(node_type)

    expect {
      click_link t('node_types.configurations')
      click_link t('node_types.delete_node_type')
      alert.accept
      ensure_on node_types_path
    }.to change(NodeType, :count).by(-1)

    page.should_not have_link node_type.name
  end

  describe "#index" do
    let(:node_type) do
      Fabricate(:node_type)
    end

    before do
      node_type
      visit node_types_path
    end

    it "show the right informations" do
      within 'h1' do
        page.should have_content t('node_types.node_types')
      end
      page.should have_link node_type.name
    end

    it "search node types", js: true do
      node_type.name = "Sample List"
      node_type.save

      ["sample", "list", "sample list"].each do |search|
        within '#node_type_search' do
          fill_in 'q', with: search
        end
        page.should have_link node_type.name
      end
    end

  end
end
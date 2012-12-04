require 'spec_helper'

describe "NodeType" do
  describe "#new" do
    describe "authorization" do
      let(:user) { Fabricate(:user) }

      specify do
        user.make_registered!
        signin user
        visit new_node_type_path
        current_path.should_not == new_node_type_path
        current_path.should == root_path
      end

      specify do
        user.make_admin!
        signin user
        visit new_node_type_path
        current_path.should == new_node_type_path
      end
    end

    describe "creates new node type" do
      let(:user) { Fabricate(:user) }
      let(:attributes) { valid_attributes_for(:node_type) }

      specify do
        user.make_admin!
        signin user
        
        visit new_node_type_path

        expect {
          fill_in t('node_types.name'), with: attributes[:name]
          fill_in t('node_types.new.title_label'), with: attributes[:title_label]
          fill_in t('node_types.description'), with: attributes[:description]
          select attributes[:filters_position].to_s, from: t('node_types.new.filters_position')
          fill_in t('node_types.new.node_expiration_day_limit'), with: attributes[:node_expiration_day_limit]
          checkbox(t('node_types.new.commentable'), attributes[:commentable])
          checkbox(t('node_types.new.signin_required'), attributes[:signin_required])
          attach_file(t('node_types.new.background_image'), "#{Rails.root}/spec/support/images/wood_background.jpg")
          click_button t('node_types.new.submit')          
        }.to change(NodeType, :count).by(1)

        page.should have_content t('node_types.dashboard')
        page.should have_content t('node_types.configurations')
        page.should have_content t('fields.fields')
        page.should have_content t('views.views')
        page.should have_content t('marketing.marketing')
        page.should have_content t('nodes.nodes')

        visit node_types_path
        page.should have_link attributes[:name]
      end
    end
  end

  describe "#destroy" do
    let(:node_type) { Fabricate(:full_featured_node_type) }
    let(:administrator) { node_type.administrators.first }

    before do
      signin administrator
      visit node_type_path(node_type)
    end

    it "deletes the node type", js: true do
      expect {
        click_link t('node_types.configurations')
        click_link t('node_types.delete_node_type')
        alert.accept
      }.to change(NodeType, :count).by(-1)

      ensure_on node_types_path
      page.should_not have_link node_type.name
    end
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
require 'spec_helper'

describe "Node" do
  let(:node_type) { Fabricate(:full_featured_node_type) }
  let(:super_administrator) { node_type.super_administrator }
  let(:user) { Fabricate(:user) }

  before do
    make_node_view(node_type)
    make_custom_view(node_type)
  end

  it "adds a node", js: true do
    signin user

    # Make new nodes to belongs to node type
    3.times do
      make_node(NodeType.class_name_to_node_type(belongs_to_field(node_type).class_name), user)
    end

    expect {
      # Node type nodes page actions
      visit node_type_nodes_path(node_type)
      click_link t('nodes.add_new_node')

      # Title
      fill_in node_type.title_label, with: Faker::Name.title

      # Belongs To Field
      select  belongs_to_field(node_type).class_name.constantize.all.first.title,
              from: belongs_to_field(node_type).label

      # BooleanField
      choose boolean_field(node_type).on_value

      # DateField
      select "1990", from: "node_#{date_field(node_type).machine_name}_1i"

      # ImageField
      page.execute_script("$('#node_#{image_field(node_type).machine_name}').css({
        'opacity': 1,
        'position': 'relative',
        'transform': 'none'  
      })")
      attach_file "node_#{image_field(node_type).machine_name}", "#{images_dir}/image-800-600.jpg"
      click_button t('images.start_upload')
      
      # IntegerField
      fill_in integer_field(node_type).label, with: "500"

      # SelectField
      find("##{select_field(node_type).machine_name} button").click
      check  select_field(node_type).options.first.name

      # PlaceField
      valid_attributes_for(:place_field)["level"].times do |i|
        select get_place_names(node_type)[i], from: "place_1_#{i}"
      end
      
      # StringField
      fill_in string_field(node_type).label, with: Faker::Lorem.sentence

      # TagField
      fill_in tag_field(node_type).label, with: Faker::Lorem.words.join(',')

      # TreeCategoryField
      get_category_names(node_type).each_with_index do |category_name, i|
        select  category_name,
                from: "category_tree_#{tree_category_field(node_type).machine_name}_#{i}"
      end

      # Submit
      click_button t('helpers.submit.update')
    }.to change(Node.pending_approval, :count).by(1)
  end

  context "when node added" do
    let(:node) { make_node(node_type, user) }
    before { node }

    it "it doesnt shows on nodes page" do
      visit node_type_nodes_path(node_type)
      page.should_not have_content node.title
    end

    it "on publish it shows on nodes page" do
      signin super_administrator
      visit node_type_path(node_type)
      page.should have_content node.title
      click_on t('nodes.publish')
      visit node_type_nodes_path(node_type)
      page.should have_content node.title
    end

    it "on reject it doesnt shows on nodes page" do
      signin super_administrator
      visit node_type_path(node_type)
      page.should have_content node.title
      
      click_on t('nodes.reject')
      visit node_type_nodes_path(node_type)
      page.should_not have_content node.title
    end
  end

  it "pagination" do
    1.times { make_node(node_type, user).publish! }

    Node.paginates_per 1

    visit node_type_nodes_path(node_type)
    page.should_not have_css ".pagination"

    # one more time
    1.times { make_node(node_type, user).publish! }
    visit node_type_nodes_path(node_type)
    page.should have_css ".pagination"
  end
end
require 'spec_helper'

describe "Node" do
  let(:node_type) { Fabricate(:full_featured_node_type) }
  let(:administrator) { node_type.administrators.first }
  let(:user) { Fabricate(:user) }

  before do
    make_node_view(node_type)
    make_custom_view(node_type)
  end

  describe "adds a node", js: true do
    specify do
      signin user

      # Rebuild Node Model
      node_type.rebuild_node_model

      # Make new nodes to belongs to node type
      3.times { make_node(belongs_to_config(node_type).parent_node_node_type, user) }

      # Node type nodes page actions
      visit node_type_nodes_path(node_type)
      click_link t('nodes.add_new_node')

      # Title
      title = Faker::Name.title
      fill_in node_type.title_label, with: title

      # Belongs To Field
      select  belongs_to_config(node_type).parent_node_node_type.nodes.first.title,
              from: belongs_to_config(node_type).label

      # BooleanField
      choose boolean_config(node_type).on_value

      # DateField
      select "1990", from: date_config(node_type).label

      # TODO ImageField
      page.execute_script "$('#hidden-form').show()"
      within("#new_fields_image") do
        attach_file "fields_image_image", "#{images_dir}/image-800-600.jpg"
        click_button t('images.add')
      end
      
      # DateField
      fill_in integer_config(node_type).label, with: "500"

      # ListField
      find("##{list_config(node_type).keyname} button").click
      check  list_config(node_type).list_items.first.name

      # PlaceField
      valid_attributes_for(:place_config)["level"].times do |i|
        select get_place_names(node_type)[i], from: "place_1_#{i}"
      end
      
      # StringField
      fill_in string_config(node_type).label, with: Faker::Lorem.sentence

      # TagField
      fill_in tag_config(node_type).label, with: Faker::Lorem.words.join(',')
            
      # TreeCategoryField
      get_category_names(node_type).each_with_index do |category_name, i|
        select  category_name,
                from: "category_tree_#{tree_category_config(node_type).machine_name}_#{i}"
      end

      # Submit
      click_button t('nodes.publish')

      signout user
      signin administrator
      
      # Manage nodes page
      visit manage_node_type_nodes_path(node_type)
      page.should have_content(title)
    end
  end

  context "when node added" do
    let(:node) do
      make_node(node_type, user)
    end

    before do
      node
    end

    it "it doesnt shows on nodes page" do
      visit node_type_nodes_path(node_type)
      page.should_not have_content node.title
    end

    it "on approved it shows on nodes page" do
      signin administrator
      visit node_type_path(node_type)
      page.should have_content node.title
      click_on t('nodes.approve')
      visit node_type_nodes_path(node_type)
      page.should have_content node.title
    end
  end
end
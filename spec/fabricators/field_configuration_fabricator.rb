Fabricator :config, class_name: "Fields::FieldConfiguration" do
  label { Faker::Lorem.words.join(' ').capitalize }
  required true
  help_text { Faker::Lorem.paragraph(2) }
end

Fabricator :belongs_to_config, from: :config, class_name: "Fields::BelongsToFieldConfiguration" do
  filter false
  can_be_added_only_by_belongs_to_node_author false
  parent_node_node_type(fabricator: :node_type_with_node)
end

Fabricator :boolean_config, from: :config, class_name: "Fields::BooleanFieldConfiguration" do
  widget_type :radio_buttons
  on_value { Faker::Lorem.word }
  off_value { Faker::Lorem.word }
end

Fabricator :date_config, from: :config, class_name: "Fields::DateFieldConfiguration" do
  date_type :year
  filter_type :range
  start_date_type :x_years_ago_start
  x_years_ago_start 50
  end_date_type :end_now
end

Fabricator :has_many_config, from: :config, class_name: "Fields::HasManyFieldConfiguration" do
  child_nodes_node_type { Fabricate(:node_type) }
end

Fabricator :image_config, from: :config, class_name: "Fields::ImageFieldConfiguration" do
  maximum_image 10
end

Fabricator :integer_config, from: :config, class_name: "Fields::IntegerFieldConfiguration" do
  filter true
  filter_type :range_with_number_field
  minimum 0
  maximum 10_000
  prefix { Faker::Lorem.word }
  suffix { Faker::Lorem.word }
  thousand_marker :none
end

Fabricator :list_config, from: :config, class_name: "Fields::ListFieldConfiguration" do
  maximum_select 0

  after_build do |config|
    config.list_items.push([
      Fabricate.build(:list_item),
      Fabricate.build(:list_item),
      Fabricate.build(:list_item),
      Fabricate.build(:list_item),
      Fabricate.build(:list_item)
    ])
  end
end

Fabricator :list_item, class_name: "Fields::ListItem" do
  name { Faker::Lorem.words.join(' ') }
end

Fabricator :place_config, from: :config, class_name: "Fields::PlaceFieldConfiguration" do
  level 2
  place_page_list false
  multiselect false
  top_place { Fabricate(:world) }
end

Fabricator :string_config, from: :config, class_name: "Fields::StringFieldConfiguration" do
  row 2
  text_format :plain
end

Fabricator :tag_config, from: :config, class_name: "Fields::TagFieldConfiguration" do
end

Fabricator :tree_category_config, from: :config, class_name: "Fields::TreeCategoryFieldConfiguration" do
  category { Fabricate(:category) }
end
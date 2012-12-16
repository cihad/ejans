Fabricator :field, class_name: "CustomFields::Fields::Default::Field" do
  label { Faker::Lorem.words.join(' ').capitalize }
  required true
  hint { Faker::Lorem.paragraph(2) }
end

Fabricator :belongs_to_field, from: :field, class_name: "CustomFields::Fields::BelongsTo::Field" do
  filter false
  can_be_added_only_by_parent_author false
  class_name { "Node#{Fabricate(:node_type_with_node).id}" }
end

Fabricator :boolean_field, from: :field, class_name: "CustomFields::Fields::Boolean::Field" do
  widget_type :radio_buttons
  on_value { Faker::Lorem.word }
  off_value { Faker::Lorem.word }
end

Fabricator :date_field, from: :field, class_name: "CustomFields::Fields::Date::Field" do
  date_type :year
  filter_type :range
  start_date_type :x_years_ago_start
  x_years_ago_start 50
  end_date_type :end_now
end

Fabricator :has_many_field, from: :field, class_name: "CustomFields::Fields::HasMany::Field" do
end

Fabricator :image_field, from: :field, class_name: "CustomFields::Fields::Image::Field" do
  maximum_image 10
end

Fabricator :integer_field, from: :field, class_name: "CustomFields::Fields::Integer::Field" do
  filter true
  filter_type :range
  minimum 0
  maximum 10_000
  prefix { Faker::Lorem.word }
  suffix { Faker::Lorem.word }
  thousand_marker :none
end

Fabricator :select_field, from: :field, class_name: "CustomFields::Fields::Select::Field" do
  maximum_select 0

  after_build do |field|
    5.times do
      field.options << Fabricate.build(:option)
    end
  end
end

Fabricator :option, class_name: "CustomFields::Fields::Select::Option" do
  name { Faker::Lorem.words.join(' ') }
end

Fabricator :place_field, from: :field, class_name: "CustomFields::Fields::Place::Field" do
  level 2
  place_page_list false
  multiselect false
  top_place { Fabricate(:world) }
end

Fabricator :string_field, from: :field, class_name: "CustomFields::Fields::String::Field" do
  row 2
  text_format :plain
end

Fabricator :tag_field, from: :field, class_name: "CustomFields::Fields::Tag::Field" do
end

Fabricator :tree_category_field, from: :field, class_name: "CustomFields::Fields::TreeCategory::Field" do
  category { Fabricate(:category) }
end
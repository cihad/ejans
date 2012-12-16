require 'spec_helper'

describe "Field", js: true do
  let(:node_type) { Fabricate(:node_type) }
  let(:administrator) { node_type.administrators.first }

  before do
    administrator.make_admin!
    signin administrator
    visit node_type_custom_fields_fields_path(node_type)
  end

  after do
    click_button t('fields.add')
    page.should have_content t('fields.messages.created')
  end

  def fill_field_default_attributes
    attributes = valid_attributes_for :field
    fill_in t('fields.label'), with: attributes[:label]
    checkbox t('fields.required'), attributes[:required]
    fill_in t('fields.hint'), with: attributes[:hint]
  end

  def fast_field_form(option)
    select option, from: "field_type"
    click_button t('fields.new_field')
  end

  it "Belongs To" do
    attributes = valid_attributes_for :belongs_to_field

    node_type = Fabricate(:node_type)
    
    fast_field_form "Belongs To"
    fill_field_default_attributes

    checkbox t('fields.filter'), attributes[:filter]
    select node_type.name, from: t('fields.belongs_to.parent_node_node_type')
  end

  it "Boolean" do
    attributes = valid_attributes_for :boolean_field

    fast_field_form "Boolean"
    fill_field_default_attributes

    checkbox t('fields.filter'), attributes[:filter]
    select attributes[:widget_type].to_s, from: t('fields.widget_type')
    fill_in t('fields.boolean.on_value'), with: attributes[:on_value]
    fill_in t('fields.boolean.off_value'), with: attributes[:off_value]
  end

  it "Date" do
    attributes = valid_attributes_for :date_field

    fast_field_form "Date"
    fill_field_default_attributes

    checkbox  t('fields.filter'), attributes[:filter]
    if attributes[:filter]
      select attributes[:filter_type].to_s, from: t('fields.filter_type')
    end
    checkbox t('fields.sort'), attributes[:sort]
    select attributes[:date_type].to_s, from: t('fields.date.date_type')

    select attributes[:start_date_type].to_s, from: t('fields.date.start_date_type')
    
    if attributes[:x_years_ago_start]
      fill_in t('fields.date.x_years_ago_start'), with: attributes[:x_years_ago_start]
    end

    if attributes[:spesific_end_date]
      fill_in t('fields.date.specific_end_date'), with: attributes[:spesific_end_date]
    end

    select attributes[:end_date_type], from: t('fields.date.end_date_type')

    if attributes[:x_years_ago_end]
      fill_in t('fields.date.x_years_ago_end'), with: attributes[:x_years_ago_end]
    end

    if attributes[:x_years_later_end]
      fill_in t('fields.date.x_years_later_end'), with: attributes[:x_years_later_end]
    end

    if attributes[:specific_end_date]
      fill_in t('fields.date.specific_end_date'), with: attributes[:specific_end_date]
    end
  end

  xit "Has Many" do
    attributes = valid_attributes_for :has_many_field
    node_type = Fabricate(:node_type)
    fast_field_form "Has Many"

    fill_field_default_attributes
    select node_type.name, from: t('fields.has_many.child_nodes_node_type')
  end

  it "Image" do
    attributes = valid_attributes_for :image_field
    fast_field_form "Image"

    fill_field_default_attributes
    fill_in t('fields.image.maximum_image'), with: attributes[:maximum_image]
  end

  it "Integer" do
    attributes = valid_attributes_for :integer_field
    fast_field_form "Integer"

    fill_field_default_attributes
    checkbox  t('fields.filter'),           attributes[:filter]

    if attributes[:filter_type]
      select    attributes[:filter_type],     from: t('fields.filter_type')
    end
    
    checkbox  t('fields.sort'),             attributes[:sort]
    fill_in   t('fields.integer.minimum'),  with: attributes[:minimum]
    fill_in   t('fields.integer.maximum'),  with: attributes[:maximum]
    fill_in   t('fields.integer.prefix'),   with: attributes[:prefix]
    fill_in   t('fields.integer.suffix'),   with: attributes[:suffix]
    select    attributes[:thousand_marker], from: t('fields.integer.thousand_marker')
  end

  it "Place" do
    attributes = valid_attributes_for :place_field
    fast_field_form "Place"

    place = Fabricate(:place)

    fill_field_default_attributes
    fill_in   t('fields.place.level'),            with: attributes[:level]
    checkbox  t('fields.place.multiselect'),      attributes[:multiselect]
    fill_in   t('fields.place.top_place_name'),   with: place.name
    checkbox  t('fields.place.place_page_list'),  attributes[:place_page_list]
  end

  it "Select" do
    attributes = valid_attributes_for :select_field
    fast_field_form "Select"

    fill_field_default_attributes
    checkbox  t('fields.filter'),                 attributes[:filter]
    fill_in   t('fields.select.maximum_select'),  with: attributes[:maximum_select]

    5.times do |i|
      fill_in "field_options_attributes_#{i}_name",
        with: valid_attributes_for(:option)[:name]
    end
  end

  it "String" do
    attributes = valid_attributes_for :string_field
    fast_field_form "String"

    fill_field_default_attributes
    checkbox  t('fields.sort'),         attributes[:sort]
    fill_in   t('fields.string.row'),   with: attributes[:row]
    select    attributes[:text_format], from: t('fields.string.text_format')
  end

  it "Tag" do
    attributes = valid_attributes_for :tag_field
    fast_field_form "Tag"

    fill_field_default_attributes
    checkbox t('fields.filter'), attributes[:filter]
  end

  it "Tree Category" do
    attributes = valid_attributes_for :tree_category_field
    category = Fabricate(:category)
    fast_field_form "Tree Category"

    fill_field_default_attributes
    checkbox  t('fields.filter'), attributes[:filter]
    select    category.name,      from: t('fields.tree_category.category')
  end


  # CustomFields::Fields::Default::Field.subclasses.each do |klass|
  #   describe "#{klass.name}" do
  #     specify { send(:"make_#{klass.type}_field") }
  #   end
  # end
end
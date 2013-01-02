require 'spec_helper'

describe "Field" do
  let(:node_type) { Fabricate(:node_type) }
  let(:super_administrator) { node_type.super_administrator }

  describe "index page authorization" do
    it "as anonymous" do
      visit node_type_custom_fields_fields_path(node_type)
      current_path.should_not be(node_type_custom_fields_fields_path(node_type))
      page.should have_content t('errors.not_authorized')
    end

    it "as registered" do
      user = Fabricate(:user)

      signin user
      visit node_type_custom_fields_fields_path(node_type)
      current_path.should_not be(node_type_custom_fields_fields_path(node_type))
      page.should have_content t('errors.not_authorized')
    end

    it "as administrator" do
      user = Fabricate(:user)

      node_type.administrators << user
      signin user
      visit node_type_custom_fields_fields_path(node_type)
      current_path.should eq(node_type_custom_fields_fields_path(node_type))
      page.should_not have_content t('errors.not_authorized')
    end

    it "as super administrator" do
      signin node_type.super_administrator
      visit node_type_custom_fields_fields_path(node_type)
      current_path.should eq(node_type_custom_fields_fields_path(node_type))
      page.should_not have_content t('errors.not_authorized')
    end

    it "as admin" do
      admin = Fabricate(:admin)
      signin admin
      visit node_type_custom_fields_fields_path(node_type)
      current_path.should eq(node_type_custom_fields_fields_path(node_type))
      page.should_not have_content t('errors.not_authorized')
    end
  end

  describe "creates", js: true do
    before do
      super_administrator.admin!
      signin super_administrator
      visit node_type_custom_fields_fields_path(node_type)
    end

    after do
      click_button t('simple_form.labels.field.create')
      page.should have_content t('fields.messages.created')
    end

    def fill_field_default_attributes
      attributes = valid_attributes_for :field
      fill_in "field_label", with: attributes[:label]
      checkbox "field_required", attributes[:required]
      fill_in "field_hint", with: attributes[:hint]
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

      checkbox "field_filter", attributes[:filter]
      select node_type.name, from: "field_class_name"
    end

    it "Boolean" do
      attributes = valid_attributes_for :boolean_field

      fast_field_form "Boolean"
      fill_field_default_attributes

      checkbox "field_filter", attributes[:filter]
      choose "field_widget_type_#{attributes[:widget_type]}"
      fill_in "field_on_value", with: attributes[:on_value]
      fill_in "field_off_value", with: attributes[:off_value]
    end

    it "Date" do
      attributes = valid_attributes_for :date_field

      fast_field_form "Date"
      fill_field_default_attributes

      checkbox  "field_filter", attributes[:filter]

      if attributes[:filter]
        choose "field_filter_type_#{attributes[:filter_type]}"
      end

      checkbox "field_sort", attributes[:sort]

      select t("simple_form.options.field.date_type.#{attributes[:date_type]}"),
        from: "field_date_type"

      select t("simple_form.options.field.start_date_type.#{attributes[:start_date_type]}"),
        from: "field_start_date_type"
      
      if attributes[:x_years_ago_start]
        fill_in "field_x_years_ago_start", with: attributes[:x_years_ago_start]
      end

      if attributes[:specific_end_date]
        fill_in "field_specific_end_date", with: attributes[:specific_end_date]
      end

      select t("simple_form.options.field.end_date_type.#{attributes[:end_date_type]}"),
          from: 'field_end_date_type'

      if attributes[:x_years_ago_end]
        fill_in 'field_x_years_ago_end', with: attributes[:x_years_ago_end]
      end

      if attributes[:x_years_later_end]
        fill_in 'field_x_years_later_end', with: attributes[:x_years_later_end]
      end

      if attributes[:specific_end_date]
        fill_in 'field_specific_end_date', with: attributes[:specific_end_date]
      end
    end

    xit "Has Many" do
      attributes = valid_attributes_for :has_many_field
      node_type = Fabricate(:node_type)
      fast_field_form "Has Many"

      fill_field_default_attributes
      select node_type.name, from: 'field_class_name'
    end

    it "Image" do
      attributes = valid_attributes_for :image_field
      fast_field_form "Image"

      fill_field_default_attributes
      fill_in 'field_maximum_image', with: attributes[:maximum_image]
    end

    it "Integer" do
      attributes = valid_attributes_for :integer_field
      fast_field_form "Integer"

      fill_field_default_attributes
      checkbox  "field_filter",           attributes[:filter]

      if attributes[:filter_type]
        choose "field_filter_type_#{attributes[:filter_type]}"
      end
      
      checkbox  "field_sort",             attributes[:sort]
      fill_in   'field_minimum',  with: attributes[:minimum]
      fill_in   'field_maximum',  with: attributes[:maximum]
      fill_in   'field_prefix',   with: attributes[:prefix]
      fill_in   'field_suffix',   with: attributes[:suffix]
      choose "field_thousand_marker_#{attributes[:thousand_marker]}"
    end

    it "Place" do
      attributes = valid_attributes_for :place_field
      fast_field_form "Place"

      place = Fabricate(:place)

      fill_field_default_attributes
      fill_in   'field_level',            with: attributes[:level]
      checkbox  'field_multiselect',      attributes[:multiselect]
      fill_in   'field_top_place_name',   with: place.name
      checkbox  'field_place_page_list',  attributes[:place_page_list]
    end

    it "Select" do
      attributes = valid_attributes_for :select_field
      fast_field_form "Select"

      fill_field_default_attributes
      checkbox  "field_filter",                 attributes[:filter]
      fill_in   'field_maximum_select',  with: attributes[:maximum_select]

      5.times do |i|
        fill_in "field_options_attributes_#{i}_name",
          with: valid_attributes_for(:option)[:name]
      end
    end

    it "String" do
      attributes = valid_attributes_for :string_field
      fast_field_form "String"

      fill_field_default_attributes
      checkbox  "field_sort",  attributes[:sort]
      fill_in   'field_row',   with: attributes[:row]
      choose    "field_text_format_#{attributes[:text_format]}"
    end

    it "Tag" do
      attributes = valid_attributes_for :tag_field
      fast_field_form "Tag"

      fill_field_default_attributes
      checkbox "field_filter", attributes[:filter]
    end

    it "Tree Category" do
      attributes = valid_attributes_for :tree_category_field
      category = Fabricate(:category)
      fast_field_form "Tree Category"

      fill_field_default_attributes
      checkbox  "field_filter", attributes[:filter]
      select    category.name,      from: 'field_category_id'
    end
  end
end
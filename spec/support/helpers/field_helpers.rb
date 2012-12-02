module FieldHelpers
  def fill_field(attrs = {}, fabricator = :config)
    attributes = change_with_custom_values(fabricator, attrs)

    fill_in t('fields.label'), with: attributes[:label]
    checkbox t('fields.required'), attributes[:required]
    fill_in t('fields.help_text'), with: attributes[:help_text]
  end

  def fast_field_form(option)
    select option, from: "_type"
    click_button t('fields.new_field')
  end

  def make_belongs_to_field(attrs = {}, fabricator = :belongs_to_config)
    attributes = change_with_custom_values(fabricator, attrs)
    node_type = Fabricate(:node_type)
    fast_field_form "Belongs To"

    fill_field
    checkbox t('fields.filter'), attributes[:filter]
    select node_type.name, from: t('fields.belongs_to.parent_node_node_type')
    click_button t('fields.add')
  end

  def make_boolean_field(attrs = {}, fabricator = :boolean_config)
    attributes = change_with_custom_values(fabricator, attrs)

    fast_field_form "Boolean"

    fill_field
    checkbox t('fields.filter'), attributes[:filter]
    select attributes[:widget_type].to_s, from: t('fields.widget_type')
    fill_in t('fields.boolean.on_value'), with: attributes[:on_value]
    fill_in t('fields.boolean.off_value'), with: attributes[:off_value]
    click_button t('fields.add')
  end

  def make_date_field(attrs = {}, fabricator = :date_config)
    attributes = change_with_custom_values(fabricator, attrs)
    fast_field_form "Date"

    fill_field
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

    click_button t('fields.add')
  end

  def make_has_many_field(attrs = {}, fabricator = :has_many_config)
    attributes = change_with_custom_values(fabricator, attrs)
    node_type = Fabricate(:node_type)
    fast_field_form "Has Many"

    fill_field
    select node_type.name, from: t('fields.has_many.child_nodes_node_type')
    click_button t('fields.add')
  end

  def make_image_field(attrs = {}, fabricator = :image_config)
    attributes = change_with_custom_values(fabricator, attrs)
    fast_field_form "Image"

    fill_field
    fill_in t('fields.image.maximum_image'), with: attributes[:maximum_image]
    click_button t('fields.add')
  end

  def make_integer_field(attrs = {}, fabricator = :integer_config)
    attributes = change_with_custom_values(fabricator, attrs)
    fast_field_form "Integer"

    fill_field
    checkbox t('fields.filter'), attributes[:filter]
    if attributes[:filter_type]
      select attributes[:filter_type], from: t('fields.filter_type')
    end
    checkbox t('fields.sort'), attributes[:sort]
    fill_in t('fields.integer.minimum'), with: attributes[:minimum]
    fill_in t('fields.integer.maximum'), with: attributes[:maximum]
    fill_in t('fields.integer.prefix'), with: attributes[:prefix]
    fill_in t('fields.integer.suffix'), with: attributes[:suffix]
    select attributes[:thousand_marker], from: t('fields.integer.thousand_marker')

    click_button t('fields.add')
  end

  def make_list_field(attrs = {}, fabricator = :list_config)
    attributes = change_with_custom_values(fabricator, attrs)
    fast_field_form "List"

    fill_field
    checkbox t('fields.filter'), attributes[:filter]
    fill_in t('fields.list.maximum_select'), with: attributes[:maximum_select]
    fill_in "fields_list_field_configuration_list_items_attributes_0_name", with: valid_attributes_for(:list_item)[:name]
    fill_in "fields_list_field_configuration_list_items_attributes_1_name", with: valid_attributes_for(:list_item)[:name]
    fill_in "fields_list_field_configuration_list_items_attributes_2_name", with: valid_attributes_for(:list_item)[:name]
    fill_in "fields_list_field_configuration_list_items_attributes_3_name", with: valid_attributes_for(:list_item)[:name]
    fill_in "fields_list_field_configuration_list_items_attributes_4_name", with: valid_attributes_for(:list_item)[:name]

    click_button t('fields.add')
  end

  def make_place_field(attrs = {}, fabricator = :place_config)
    attributes = change_with_custom_values(fabricator, attrs)
    fast_field_form "Place"

    place = Fabricate(:place)

    fill_field
    fill_in t('fields.place.level'), with: attributes[:level]
    checkbox t('fields.place.multiselect'), attributes[:multiselect]
    fill_in t('fields.place.top_place_name'), with: place.name
    checkbox t('fields.place.place_page_list'), attributes[:place_page_list]
    click_button t('fields.add')
  end

  def make_string_field(attrs = {}, fabricator = :string_config)
    attributes = change_with_custom_values(fabricator, attrs)
    fast_field_form "String"

    fill_field
    checkbox t('fields.sort'), attributes[:sort]
    fill_in t('fields.string.row'), with: attributes[:row]
    select attributes[:text_format], from: t('fields.string.text_format')
    click_button t('fields.add')
  end

  def make_tag_field(attrs = {}, fabricator = :tag_config)
    attributes = change_with_custom_values(fabricator, attrs)
    fast_field_form "Tag"

    fill_field
    checkbox t('fields.filter'), attributes[:filter]
    click_button t('fields.add')
  end

  def make_tree_category_field(attrs = {}, fabricator = :tree_category_config)
    attributes = change_with_custom_values(fabricator, attrs)
    category = Fabricate(:category)
    fast_field_form "Tree Category"

    fill_field
    checkbox t('fields.filter'), attributes[:filter]
    select category.name, from: t('fields.tree_category.category')
    click_button t('fields.add')
  end
end
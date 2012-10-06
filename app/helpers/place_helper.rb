module PlaceHelper
  def link_to_add_place(field)
    new_object = field.value.build
    id = new_object.object_id
    fields = field.f.fields_for field.form_key, new_object, child_index: id do |f|
      render 'fields/place/place_item', field: field, builder: f
    end

    link_to 'add_place',
            '#add',
            class: "add-place",
            data: {
              id: id,
              fields: fields.gsub('\n', '')
            }
  end
end
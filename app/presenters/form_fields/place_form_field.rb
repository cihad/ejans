module FormFields
  class PlaceFormField < FormField

    delegate :multiselect?, :level, :top_place, :form_level_names, to: :field

    def tree
      @tree ||= levels
    end

    def levels
      levels = top_place.levels
      levels.shift
      levels.first(level)
    end

    def place_ids_name
      :"#{keyname.to_s.singularize}_ids"
    end

    def build_place
      if multiselect? or (!multiselect? and value.size == 0 )
        value.build
      end
    end

    def link_to_add_place
      new_object = value.build
      id = new_object.object_id
      fields = f.fields_for form_key, new_object, child_index: id do |builder|
        render 'fields/place/place_item', field: self, builder: builder
      end

      link_to 'add_place',
              '#add',
              class: "add-place",
              data: {
                id: id,
                fields: fields.gsub('\n', '')
              }
    end

    def link_to_remove_place
      link_to 'remove', '#remove', class: 'destroy-place btn btn-danger'
    end
  end
end
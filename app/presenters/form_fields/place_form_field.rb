module FormFields
  class PlaceFormField < FormField
    def multiselect?
      field.multiselect?
    end

    def level
      field.level
    end

    def top_place
      field.top_place
    end

    def form_level_names
      field.form_level_names
    end

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
        @template.render 'fields/place/place_item', field: self, builder: builder
      end

      @template.link_to 'add_place',
                        '#add',
                        class: "add-place",
                        data: {
                          id: id,
                          fields: fields.gsub('\n', '')
                        }
    end

    def link_to_remove_place
      @template.link_to 'remove', '#remove', class: 'destroy-place btn btn-danger'
    end
  end
end
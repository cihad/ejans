module CustomFields
  module Fields
    module HasMany



      module ApplyCustomField
        def apply_has_many_custom_field(klass, rule)
          klass.has_many rule['keyname'].to_sym,
            class_name: rule['child_class_name'],
            inverse_of: rule['inverse_of'].to_sym,
            dependent: :destroy,
            validate: false
        end
      end
      

      module ApplyValidate
        def apply_has_many_validate(klass, rule); end
      end


      class Field < ::CustomFields::Fields::Default::Field
        include ::CustomFields::Relationable
        extend ApplyCustomField
        extend ApplyValidate

        ## fields
        field :inverse_of, type: ::Symbol

        ## associations
        belongs_to :child_nodes_node_type, class_name: "NodeType"

        ## callbacks
        after_create :create_belongs_to_field_other_side

        def custom_recipe
          {}
        end

      private
        def create_belongs_to_field_other_side
          unless inverse_of
            conf = child_nodes_node_type.
              field_configurations.
              create(
                { inverse_of: keyname,
                  label: node_type.name,
                  parent_node_node_type: node_type },
                BelongsToFieldConfiguration
              )
            self.inverse_of = conf.keyname
            self.save
          end
        end
      end



    end
  end
end
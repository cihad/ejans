module CustomFields
  module Fields
    module String



      module ApplyCustomField
        def apply_string_custom_field(klass, rule)
          klass.field rule['keyname'].to_sym,
            as: rule['machine_name'].to_sym,
            type: ::String
        end
      end



      module ApplyValidate
        def apply_string_validate(klass, rule)
          if rule['required']
            klass.validates_presence_of rule['machine_name'].to_sym
          end
        end
      end



      class Field < ::CustomFields::Fields::Default::Field
        include ::CustomFields::Sortable
        extend ApplyCustomField
        extend ApplyValidate
        
        TEXT_FORMATS = [:plain, :simple, :extended]    

        ## fields
        field :row,         type: ::Integer, default: 1
        field :text_format, type: ::Symbol,  default: :plain

        ## validates
        validates :text_format, inclusion: { in: TEXT_FORMATS }
        
        def fill_node_with_random_value(node)
          node.send("#{machine_name}=", Faker::Lorem.sentences.join(' '))
        end

        def custom_recipe
          { 'row'         => row,
            'text_format' => text_format }
        end
      end




    end
  end
end
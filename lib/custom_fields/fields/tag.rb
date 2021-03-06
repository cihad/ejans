module CustomFields
  module Fields
    module Tag



      module ApplyCustomField
        def apply_tag_custom_field(klass, rule)
          klass.field rule['keyname'].to_sym,
            as: rule['machine_name'].to_sym,
            type: ::Array,
            default: []

          klass.class_eval do
            define_method "#{rule['keyname']}_tags" do
              self[rule['keyname']].join(', ')
            end
            alias :"#{rule['machine_name']}_tags" :"#{rule['keyname']}_tags"
          end
        end
      end



      module ApplyValidate
        def apply_tag_validate(klass, rule)
          if rule['required']
            klass.validates_presence_of "#{rule['keyname']}_tags".to_sym
          end

          klass.class_eval <<-EOM, __FILE__, __LINE__ + 1
            def #{rule['keyname']}_tags=(tags)
              self.#{rule['keyname']} = tags.split(',').map(&:strip)
            end
          EOM
        end
      end



      module Query
        def tag_criteria(params, rule)
          tags = params[rule['machine_name']].split(',').map(&:strip)
          ::CustomFields::Criteria.new.all(where_is_tag(rule) => tags)
        end

        def tag_param_exist?(params, rule)
          params[rule['machine_name']].present?
        end

        def where_is_tag(rule)
          rule['keyname'].to_sym
        end
      end



      class Field < ::CustomFields::Fields::Default::Field
        include ::CustomFields::Filterable
        extend ApplyCustomField
        extend ApplyValidate
        extend Query

        def fill_node_with_random_value(node)
          node.send("#{keyname}_tags=", Faker::Lorem.words.join(','))
        end

        def custom_recipe
          {}
        end
      end



    end
  end
end
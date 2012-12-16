module CustomFields
  module Fields
    module TreeCategory



      module ApplyCustomField
        def apply_tree_category_custom_field(klass, rule)
          klass.has_and_belongs_to_many rule['keyname'].to_sym,
            class_name: "Category",
            inverse_of: nil

          klass.class_eval <<-EOM, __FILE__, __LINE__ + 1
            alias :#{rule['machine_name']} :#{rule['keyname']}
            alias :#{rule['machine_name']}= :#{rule['keyname']}=
          EOM
        end
      end



      module ApplyValidate
        def apply_tree_category_validate(klass, rule)
          if rule['required']
            klass.validates_presence_of rule['machine_name'].to_sym
          end
        end
      end



      module Query
        def tree_category_criteria(params, rule)
          levels_size = ::Category.find(rule['category_id']).levels_unless_self.size
          criteria = ::CustomFields::Criteria.new

          machine_names = tree_category_machine_names(rule, levels_size)

          levels_size.times do |i|
            id = params[machine_names[-(i+1)]]
            if id.present?
              criteria.in(where_is_tree_category(rule) => [id])
              break
            end
          end

          criteria
        end

        def tree_category_param_exist?(params, rule)
          true
        end

        def where_is_tree_category(rule)
          "#{rule['keyname']}_ids".to_sym
        end

        def tree_category_machine_names(rule, levels_size)
          1.upto(levels_size).map { |i| "#{rule['machine_name']}_level_#{i}" }
        end
      end




      class Field < ::CustomFields::Fields::Default::Field
        include ::CustomFields::Filterable
        extend ApplyCustomField
        extend ApplyValidate
        extend Query
        
        ## associations
        belongs_to :category, class_name: "::Category"

        ## validations
        validates :category, presence: true

        def fill_node_with_random_value(node)
          node.send("#{machine_name}=", category.get_just_a_branch)
        end

        def custom_recipe
          { 'category_id' => category.id.to_s }
        end
      end




    end
  end
end
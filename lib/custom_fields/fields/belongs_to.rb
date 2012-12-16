module CustomFields
  module Fields
    module BelongsTo



      module ApplyCustomField
        def apply_belongs_to_custom_field(klass, rule)
          klass.belongs_to rule['keyname'].to_sym,
            class_name: rule['class_name'],
            inverse_of: rule['inverse_of'].try(:to_sym)

          klass.class_eval <<-EOM, __FILE__, __LINE__ + 1
            alias :#{rule['machine_name']} :#{rule['keyname']}
            alias :#{rule['machine_name']}= :#{rule['keyname']}=
            alias :#{rule['machine_name']}_id :#{rule['keyname']}_id
            alias :#{rule['machine_name']}_id= :#{rule['keyname']}_id=
          EOM
        end
      end


      module ApplyValidate
        def apply_belongs_to_validate(klass, rule)
          if rule['required']
            klass.validates_presence_of rule['keyname'].to_sym
          end

          if rule['can_be_added_only_by_parent_author']
            klass.validate :"#{rule['machine_name']}_can_be_added_only_by_parent_author"

            klass.class_eval <<-EOV, __FILE__, __LINE__ + 1
              private
              def #{rule['machine_name']}_can_be_added_only_by_parent_author
                if author != #{machine_name}.try(:author)
                  errors.add(:#{machine_name},
                    %q{node ekleyebilmek icin once
                      <a href='#'>buradan</a>
                      ust bir dugum eklemelisiniz. Sonra buradan eklediginiz
                      node'ye referans verebilirsiniz.}.html_safe)
                end
              end
            EOV
          end
        end
      end


      module Query
        def belongs_to_criteria(params, rule)
          ids = params[rule['machine_name']].map { |id| ::Moped::BSON::ObjectId(id) }
          ::CustomFields::Criteria.new.in( where_is_belongs_to(rule) => ids )
        end

        def belongs_to_param_exist?(params, rule)
          params[rule['machine_name']].present?
        end

        def where_is_belongs_to(rule)
          "#{rule['keyname']}_id".to_sym
        end
      end



      class Field < ::CustomFields::Fields::Default::Field
        include ::CustomFields::Filterable
        include ::CustomFields::Relationable
        extend ApplyCustomField
        extend ApplyValidate
        extend Query

        ## fields
        field :can_be_added_only_by_parent_author, type: ::Boolean

        def custom_recipe
          { 'class_name'  => class_name,
            'inverse_of'  => inverse_of,
            'can_be_added_only_by_parent_author' => can_be_added_only_by_parent_author }
        end

        def fill_node_with_random_value(node)
          parent_node = if can_be_added_only_by_parent_author
                          node.author.nodes.where(_type: class_name).first
                        else
                          class_name.constantize.all.first
                        end
          node.send("#{machine_name}=", parent_node)
        end

      end




    end
  end
end
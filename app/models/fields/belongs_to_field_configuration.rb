module Fields
  class BelongsToFieldConfiguration < FieldConfiguration
    include Ejans::Fields::Filterable
    include Rails.application.routes.url_helpers
    field :inverse_of, type: Symbol
    field :can_be_added_only_by_belongs_to_node_author, type: Boolean
    belongs_to :parent_node_node_type, class_name: "NodeType"
    after_create :create_has_many_field_other_side

    before_destroy :destroy_the_has_many_field_other_side

    def set_specifies
      parent_node_node_type
      node_klass.instance_eval <<-EOM
        belongs_to :#{keyname},
          class_name: "#{parent_node_node_type.node_classify_name}",
          inverse_of: :#{inverse_of}

        validate :#{keyname}_presence_value
        validate :#{keyname}_can_be_added_only_by_belongs_to_node_author
      EOM
      
      node_klass.class_eval <<-EOM
        alias :#{machine_name} :#{keyname}
        alias :#{machine_name}= :#{keyname}=

        private
        def #{keyname}_presence_value
          if #{required?} and #{keyname}.blank?
            errors.add(:#{keyname}, 'bos birakilamaz')
          end
        end

        def #{keyname}_can_be_added_only_by_belongs_to_node_author
          if #{can_be_added_only_by_belongs_to_node_author?} and author != #{keyname}.try(:author)
            errors.add(:#{keyname},
              %q{node ekleyebilmek icin once
                <a href='#{node_type_path(parent_node_node_type)}'>buradan</a>
                ust bir dugum eklemelisiniz. Sonra buradan eklediginiz
                node'ye referans verebilirsiniz.}.html_safe)
          end
        end
      EOM
    end

    def filter_query(params = {})
      if params[machine_name].present?
        ids = params[machine_name].map { |id| Moped::BSON::ObjectId(id) }
        BlankCriteria.new.in( :"#{where}" => ids )
      else
        BlankCriteria.new
      end
    end

    def fill_node_with_random_value(node)
      parent_node = if can_be_added_only_by_belongs_to_node_author
                      node.author.nodes.where(id: parent_node_node_type.id).first
                    else
                      parent_node_node_type.nodes.first
                    end
      node.send("#{machine_name}=", parent_node)
    end

    private
    def where
      keyname.to_s + "_id"
    end

    def create_has_many_field_other_side
      unless inverse_of
        conf = parent_node_node_type.
          field_configurations.
          create(
            { inverse_of: keyname,
              label: node_type.name,
              child_nodes_node_type: node_type },
            HasManyFieldConfiguration
          )
        self.inverse_of = conf.keyname
        self.save
      end
    end

    def destroy_the_has_many_field_other_side
      parent_node_node_type.
        field_configurations.
        select { |conf| conf.keyname == inverse_of }.
        first.
        destroy
    end
  end
end
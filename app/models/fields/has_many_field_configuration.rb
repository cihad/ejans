module Fields
  class HasManyFieldConfiguration < FieldConfiguration
    field :inverse_of, type: Symbol
    belongs_to :child_nodes_node_type, class_name: "NodeType"
    after_create :create_belongs_to_field_other_side

    def set_specifies
      child_nodes_node_type
      node_klass.instance_eval <<-EOM
        has_many :#{keyname},
          class_name: "#{child_nodes_node_type.node_classify_name}",
          inverse_of: :#{inverse_of},
          dependent: :destroy,
          validate: false
      EOM
      
      node_klass.class_eval <<-EOM
        def #{machine_name}
          #{keyname}
        end
      EOM
    end

    private
    def where
      keyname.to_s + "_id"
    end

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
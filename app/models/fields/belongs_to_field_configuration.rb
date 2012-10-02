module Fields
  class BelongsToFieldConfiguration < FieldConfiguration
    include Ejans::Fields::Filterable
    field :inverse_of, type: Symbol
    belongs_to :parent_node_node_type, class_name: "NodeType"
    after_create :create_has_many_field_other_side

    before_destroy :destroy_the_has_many_field_other_side

    def set_specifies
      parent_node_node_type
      node_klass.instance_eval <<-EOM
        belongs_to :#{keyname},
          class_name: "#{parent_node_node_type.node_classify_name}",
          inverse_of: :#{inverse_of}
      EOM
      
      node_klass.class_eval <<-EOM
        def #{machine_name}
          begin
            #{keyname}
          rescue
            nil
          end
        end
      EOM
    end

    def filter_query(params = {})
      if params[machine_name].present?
        ids = params[machine_name].map { |id| Moped::BSON::ObjectId(id) }
        NodeQuery.new.in( :"#{where}" => ids )
      else
        NodeQuery.new
      end
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
              child_nodes_node_type: self },
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
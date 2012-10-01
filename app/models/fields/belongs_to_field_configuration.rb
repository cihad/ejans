module Fields
  class BelongsToFieldConfiguration < FieldConfiguration
    include Ejans::Fields::Filterable
    belongs_to :belongs_to_node_type, class_name: "NodeType"

    def set_specifies
      belongs_to_node_type

      node_klass.instance_eval <<-EOM
        belongs_to :#{keyname}, class_name: "#{belongs_to_node_type.node_classify_name}"
      EOM
      
      node_klass.class_eval <<-EOM
        def #{machine_name}
          #{keyname}
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
  end
end
module Fields
  class BooleanFieldConfiguration < FieldConfiguration
    include Ejans::Fields::Filterable

    field :widget_type, type: Symbol
    WIDGET_TYPES = [:radio_buttons, :single_on_off]
    field :on_value, type: String
    field :off_value, type: String

    def set_specifies
      node_klass.instance_eval <<-EOM
        field :#{keyname}, type: Boolean
      EOM

      node_klass.class_eval <<-EOM
        def #{machine_name}
          #{keyname}
        end
      EOM
    end

    def filter_query(params = {})
      value = params[machine_name]
      if value.present? and ["0", "1"].include?(value)
        true_or_false = value == "1" ? true : false
        NodeQuery.new.where(keyname => true_or_false)
      else
        NodeQuery.new
      end
    end
  end
end
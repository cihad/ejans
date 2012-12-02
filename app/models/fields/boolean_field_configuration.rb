module Fields
  class BooleanFieldConfiguration < FieldConfiguration
    include Ejans::Fields::Filterable

    field :widget_type, type: Symbol
    WIDGET_TYPES = [:radio_buttons, :single_on_off]
    field :on_value, type: String
    field :off_value, type: String

    def set_specifies
      node_klass.instance_eval <<-EOM
        field :#{keyname}, as: :#{machine_name}, type: Boolean
      EOM
    end

    def filter_query(params = {})
      value = params[machine_name]
      if value.present? and ["0", "1"].include?(value)
        true_or_false = value == "1" ? true : false
        BlankCriteria.new.where(keyname => true_or_false)
      else
        BlankCriteria.new
      end
    end

    def fill_node_with_random_value(node)
      node.send("#{machine_name}=", true)
    end
  end
end
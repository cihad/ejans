module Mongoid
  module Factory

    def from_db_with_custom_fields(klass, attributes = nil, criteria_instance_id = nil)
      if klass.with_custom_fields?
        klass.klass_with_custom_fields(attributes['custom_fields_recipe'])
      end
      from_db_without_custom_fields(klass, attributes, criteria_instance_id)
    end
    alias_method_chain :from_db, :custom_fields
    
  end
end
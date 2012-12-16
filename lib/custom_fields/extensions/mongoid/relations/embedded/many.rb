module Mongoid
  module Relations
    module Embedded

      class Many < Relations::Many

          def build_with_custom_fields(attributes = {}, options = {}, type = nil)
            if base.respond_to?(:embedded_fields_for?) and base.embedded_fields_for?(metadata.name)
              field_type = attributes.delete(:type)
              options = base.class.field_klass_with_custom_fields(field_type).constantize if field_type
            end

            build_without_custom_fields(attributes, options, type)
          end
          alias_method_chain :build, :custom_fields

      end

    end
  end
end
module CustomFields
  module Fields
    module Boolean



      module ApplyCustomField
        def apply_boolean_custom_field(klass, rule)
          klass.field rule['keyname'].to_sym,
            as: rule['machine_name'].to_sym,
            type: ::Boolean

          klass.class_eval do
            define_method rule['machine_name'].to_sym do
              Presenter.new(self[rule['keyname']], rule)
            end
          end
        end
      end


      module ApplyValidate
        def apply_boolean_validate(klass, rule)
          if rule['required']
            klass.validates_presence_of rule['keyname'].to_sym
          end
        end
      end


      module Query
        def boolean_criteria(params, rule)
          value = params[rule['machine_name']]
          true_or_false = %w(1 true yes).include?(value) ? true : false
          ::CustomFields::Criteria.new.where( where_is_boolean(rule) => true_or_false)
        end

        def boolean_param_exist?(params, rule)
          value = params[rule['machine_name']]
          value.present? and %w(0 1 true false yes no).include?(value)
        end

        def where_is_boolean(rule)
          rule['keyname'].to_sym
        end
      end



      class Field < ::CustomFields::Fields::Default::Field
        include ::CustomFields::Filterable
        extend ApplyCustomField
        extend ApplyValidate
        extend Query
        
        WIDGET_TYPES = [:radio_buttons, :single_on_off]

        ## fields
        field :widget_type, type: ::Symbol
        field :on_value
        field :off_value

        def custom_recipe
          { 'widget_type' => widget_type,
            'on_value'    => on_value,
            'off_value'   => off_value }
        end

        def fill_node_with_random_value(node)
          node.send("#{keyname}=", true)
        end
      end



      class Presenter < ::CustomFields::Fields::Default::Presenter

        # source = true|false
        def to_s
          source ? on_value : off_value
        end

        private

        def on_value
          metadata['on_value']
        end

        def off_value
          metadata['off_value']
        end
      end


      
    end
  end
end
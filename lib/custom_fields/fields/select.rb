module CustomFields
  module Fields
    module Select



      module ApplyCustomField
        def apply_select_custom_field(klass, rule)
          klass.has_and_belongs_to_many rule['keyname'].to_sym,
            class_name: "::CustomFields::Fields::Select::Option"

          klass.class_eval <<-EOM, __FILE__, __LINE__ + 1
            alias :#{rule['machine_name']} :#{rule['keyname']}
            alias :#{rule['machine_name']}= :#{rule['keyname']}=
          EOM
        end
      end


      module ApplyValidate
        def apply_select_validate(klass, rule)
          if rule['required']
            klass.validates_presence_of rule['machine_name']
          end

          if rule['maximum_select'] and rule['maximum_select'] != 0
            klass.validates_length_of rule['machine_name'].to_sym,
              maximum: rule['maximum_select']
          end
        end
      end


      module Query
        def select_criteria(params, rule)
          ids = params[rule['machine_name']].map { Moped::BSON::ObjectId(id) }
          ::CustomFields::Criteria.new.in(where_is_select(rule) => ids)
        end

        def select_param_exist?(params, rule)
          params[rule['machine_name']].present?
        end

        def where_is_select(rule)
          "#{params[rule['keyname']].to_s.singularize}_ids".to_sym
        end
      end



      class Option
        include ::Mongoid::Document
        field :name
        field :position, type: ::Integer, default: 0
        validates_presence_of :name
        default_scope order_by([:position, :asc])
      end

      

      class Field < ::CustomFields::Fields::Default::Field
        include ::CustomFields::Filterable
        extend ApplyCustomField
        extend ApplyValidate
        extend Query
        
        ## fields
        field :maximum_select, type: ::Integer, default: 0

        ## validations
        validates :maximum_select, presence: true

        ## associations
        has_and_belongs_to_many :options, inverse_of: nil
        accepts_nested_attributes_for :options,
          reject_if: ->(attrs){ attrs[:name].blank? }

        def fill_node_with_random_value(node)
          max = maximum_select <= 1 ? 1 : maximum_select
          selected_options = Random.rand(1..max).times.inject([]) do |arr, i|
            arr << options[i]
          end
          node.send("#{machine_name}=", selected_options)
        end

        def custom_recipe
          { 'maximum_select' => maximum_select }
        end

        private
        def assign_keyname
          name_prefix = 0
          while siblings.map(&:keyname).include?(name = "#{I18n.with_locale(:en) { name_prefix.to_words }}_select_options".to_sym)
            name_prefix = name_prefix.next
          end
          name
        end
      end




    end
  end
end
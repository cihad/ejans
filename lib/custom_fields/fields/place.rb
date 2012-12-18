module CustomFields
  module Fields
    module Place



      module ApplyCustomField
        def apply_place_custom_field(klass, rule)
          klass.embeds_many rule['keyname'].to_sym, 
            class_name: "::CustomFields::Fields::Place::PlaceItem",
            as: :able_to_place_item

          klass.accepts_nested_attributes_for rule['keyname'],
            allow_destroy: true

          klass.class_eval <<-EOM, __FILE__, __LINE__ + 1
            alias :#{rule['machine_name']} :#{rule['keyname']}
            alias :#{rule['machine_name']}= :#{rule['keyname']}=
          EOM
        end
      end



      module ApplyValidate
        def apply_place_validate(klass, rule)
          klass.before_validation do |doc|
            doc.send(rule['machine_name']).each do |plc|
              plc.delete if plc.place_ids.size == 0
            end
          end

          if rule['required']
            klass.validates_presence_of rule['machine_name'].to_sym
          end
        end
      end



      module Query
        def place_criteria(params, rule)
          criteria = ::CustomFields::Criteria.new
          rule['level'].times do |i|
            id = params[place_machine_names(rule)[-(i+1)]]
            if id.present?
              criteria = criteria.in(where_is_place(rule) => [Moped::BSON::ObjectId(id)])
              break
            end
          end

          criteria
        end

        def place_param_exist?(params, rule)
          true
        end

        def where_is_place(rule)
          "#{rule['keyname']}.place_ids".to_sym
        end

        def place_machine_names(rule)
          rule['level'].times.map { |i| "#{rule['machine_name']}_#{i}" }
        end
      end



      class PlaceItem
        include ::Mongoid::Document
        embedded_in :able_to_place_item, polymorphic: true
        has_and_belongs_to_many :places, class_name: "::Place"
        accepts_nested_attributes_for :places
      end


      class Field < ::CustomFields::Fields::Default::Field
        include ::CustomFields::Filterable
        extend ApplyCustomField
        extend ApplyValidate
        extend Query
        
        ## fields
        field :level,           type: ::Integer
        field :place_page_list, type: ::Boolean, default: false
        field :multiselect,     type: ::Boolean, default: false

        ## associations
        belongs_to :top_place, class_name: "Place"

        ## validations
        validates :level, numericality: { greater_than_or_equal_to: 1 }
        validates :top_place, presence: true

        ## callbacks
        after_save :create_place_view

        def top_place_name
          top_place.try(:hierarchical_name)
        end

        def top_place_name=(name)
          self.top_place = ::Place.find_by(name: name.split(">").map(&:strip)[-1]) if name.present?
        end

        def fill_node_with_random_value(node)
          place = PlaceItem.new(places: top_place.get_just_a_branch, able_to_place_item: node)
          node.send("#{machine_name}") << place
        end

        def custom_recipe
          { 'level'           => level,
            'multiselect'     => multiselect }
        end

        private
        def create_place_view
          if place_page_list and node_type.place_page_view.blank?
            node_type.build_place_page_view().save(validate: false)
          elsif place_page_list_changed? and !place_page_list
            node_type.place_page_view.try(:destroy)
          end
        end

        def assign_keyname
          name_prefix = 0
          while siblings.map(&:keyname).include?(name = "#{I18n.with_locale(:en) { name_prefix.to_words }}_places".to_sym)
            name_prefix = name_prefix.next
          end
          name
        end
      end





    end
  end
end
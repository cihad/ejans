module CustomFields
  module Fields
    module Default



      class Field
        include ::Mongoid::Document
        include ::Mongoid::Timestamps

        ## fields
        field :label
        field :keyname
        field :machine_name
        field :required, type: ::Boolean, default: false
        field :hint, default: ""
        field :position, type: ::Integer, default: 1000

        ## scopes
        scope :filtered_fields, where(filter: true)
        scope :sortable_fields, where(sort: true)
        default_scope order_by([:position, :asc])

        ## validations
        validates :label, presence: true
        validates_exclusion_of  :machine_name, :in => lambda { |f| CustomFields.reserved_names.map(&:to_s) }
        validate :uniqueness_of_label

        ## callbacks
        before_validation do label.strip! end
        before_validation :set_keyname
        before_validation :set_machine_name
        after_save do _parent.save end
        after_destroy do _parent.save end

        def self.filterable?
          false
        end

        def self.sortable?
          false
        end

        def self.type
          (name = self.name.split('::')).pop
          name.last.underscore
        end

        def self_data
          { machine_name.to_sym => self }
        end

        def fill_node_with_random_value(node) end

        def type
          self.class.type
        end

        def to_recipe
          { 'keyname'       => keyname,
            'label'         => label,
            'machine_name'  => machine_name,
            'type'          => type,
            'hint'          => hint,
            'required'      => required?
          }.merge(custom_recipe)
        end

        def as_json(options = {})
          method_name     = :"#{self.type}_as_json"
          custom_as_json  = self.send(method_name) rescue {}

          super(options).merge(custom_as_json)
        end

        def collect_diff(memo)
          if self.persisted?
            if self.destroyed?
              memo['$unset'][self.name] = 1
            elsif self.changed?
              if self.changes.key?(:keyname)
                old_name, new_name = self.changes[:keyname]
                memo['$rename'][old_name] = new_name
              end
            end
          end

          (memo['$set']['custom_fields_recipe.rules'] ||= []) << self.to_recipe

          memo
        end

        def filter_query(params)
          self.class.filter_query(params, to_recipe)
        end

        def self.filter_query(params, rule)
          if send(:"#{type}_param_exist?", params, rule)
            send(:"#{type}_criteria", params, rule)
          else
            CustomFields::Criteria.new
          end
        end

      protected
        def uniqueness_of_label
          if siblings.any? { |f| f.label == self.label }
            errors.add(:label, :taken)
          end
        end

        def siblings
          self._parent.send(self.metadata.name).select { |f| f != self }
        end

        def assign_keyname
          name = "#{type}_0"
          while siblings.any? { |f| f.keyname == keyname }
            name = name.next
          end
          name
        end

        def set_keyname
          self.keyname = assign_keyname unless keyname
        end

        def set_machine_name
          unless machine_name
            self.machine_name = label.parameterize('_').gsub('-', '_')
          end
        end
      end

      class Presenter

        attr_reader :source, :metadata

        def initialize(source, metadata)
          @source = source
          @metadata = metadata
        end

        private

        def keyname
          metadata['keyname']
        end

        def machine_name
          metadata['machine_name']
        end
        
      end





    end
  end
end
module CustomFields

  module Source

    extend ActiveSupport::Concern

    included do
      cattr_accessor :_custom_fields_for
      self._custom_fields_for = []

      attr_accessor :_custom_fields_diff
    end

    # Determines if the relation is enhanced by the custom fields
    #
    # @example the Person class has somewhere in its code this: "custom_fields_for :addresses"
    #   person.custom_fields_for?(:addresses)
    #
    # @param [ String, Symbol ] name The name of the relation.
    #
    # @return [ true, false ] True if enhanced, false if not.
    #
    def custom_fields_for?(name)
      self.class.custom_fields_for?(name)
    end

    # Determines if the relation is enhanced by the custom fields
    #
    # @example the Person class has somewhere in its code this: "custom_fields_for :addresses"
    #   person.custom_fields_for?(:addresses)
    #
    # @param [ String, Symbol ] name The name of the relation.
    #
    # @return [ true, false ] True if enhanced, false if not.
    #
    def embedded_fields_for?(name)
      self.class.embedded_fields_for?(name)
    end

    # Returns the class enhanced by the custom fields.
    # Be careful, call this method only if the source class
    # has been saved with success.
    #
    # @param [ String, Symbol ] name The name of the relation.
    #
    # @return [ Class ] The modified class.
    #
    def klass_with_custom_fields(name)
      # Rails.logger.debug "[CustomFields] klass_with_custom_fields #{self.send(name).metadata.klass} / #{self.send(name).metadata[:old_klass]}" if defined?(Rails) # DEBUG
      recipe    = self.custom_fields_recipe_for(name)
      _metadata = self.send(name).metadata
      target    = _metadata[:original_klass] || _metadata.klass # avoid to use an already enhanced klass
      target.klass_with_custom_fields(recipe)
    end

    # Returns the ordered list of custom fields for a relation
    #
    # @example the Person class has somewhere in its code this: "custom_fields_for :addresses"
    #   person.ordered_custom_fields(:addresses)
    #
    # @param [ String, Symbol ] name The name of the relation.
    #
    # @return [ Collection ] The ordered list.
    #
    def ordered_custom_fields(name)
      self.send(:"#{name}_custom_fields")
    end

    # Returns the recipe (meaning all the rules) needed to
    # build the custom klass
    #
    # @param [ String, Symbol ] name The name of the relation.
    #
    # @return [ Array ] An array of hashes
    #
    def custom_fields_recipe_for(name)
      {
        'name'     => "#{name.to_s.classify}#{self._id}",
        'rules'    => self.ordered_custom_fields(name).map(&:to_recipe),
        'version'  => self.custom_fields_version(name)
      }
    end

    # Returns the number of the version for relation with custom fields
    #
    # @param [ String, Symbol ] name The name of the relation.
    #
    # @return [ Integer ] The version number
    #
    def custom_fields_version(name)
      self.send(:"#{name}_custom_fields_version") || 0
    end

    # When the fields have been modified and before the object is saved,
    # we bump the version.
    #
    # @param [ String, Symbol ] name The name of the relation.
    #
    def bump_custom_fields_version(name)
      version = self.custom_fields_version(name) + 1
      self.send(:"#{name}_custom_fields_version=", version)
    end

    # Change the metadata of a relation enhanced by the custom fields.
    # In Mongoid, all the instances of a same document share the same metadata objects.
    #
    # @param [ String, Symbol ] name The name of the relation.
    #
    def refresh_metadata_with_custom_fields(name)
      return if !self.persisted? || self.send(:"#{name}_custom_fields").blank? # do not generate a klass without all the information

      old_metadata = self.send(name).metadata

      # puts "old_metadata = #{old_metadata.klass.inspect} / #{old_metadata.object_id.inspect}" # DEBUG

      self.send(name).metadata = old_metadata.clone.tap do |metadata|
        # Rails.logger.debug "[CustomFields] refresh_metadata_with_custom_fields #{metadata.klass}" if defined?(Rails) # DEBUG

        # backup the current klass
        metadata[:original_klass] ||= metadata.klass

        metadata.instance_variable_set(:@klass, self.klass_with_custom_fields(name))
      end

      # puts "new_metadata = #{self.send(name).metadata.klass.inspect} / #{self.send(name).metadata.object_id.inspect}" # DEBUG
    end

    # Initializes the object tracking the modifications
    # of the custom fields
    #
    # @param [ String, Symbol ] name The name of the relation.
    #
    def initialize_custom_fields_diff(name)
      self._custom_fields_diff ||= {}
      self._custom_fields_diff[name] = { '$set' => {}, '$unset' => {}, '$rename' => {} }
    end

    # Collects all the modifications of the custom fields
    #
    # @param [ String, Symbol ] name The name of the relation.
    #
    # @return [ Array ] An array of hashes storing the modifications
    #
    def collect_custom_fields_diff(name, fields)
      # puts "==> collect_custom_fields_diff for #{name}, #{fields.size}" # DEBUG

      memo = self.initialize_custom_fields_diff(name)

      fields.map do |field|
        field.collect_diff(memo)
      end
    end

    # Apply the modifications collected from the custom fields by
    # updating all the documents of the relation.
    # The update uses the power of mongodb to make it fully optimized.
    #
    # @param [ String, Symbol ] name The name of the relation.
    #
    def apply_custom_fields_diff(name)
      # puts "==> apply_custom_fields_recipes for #{name}, #{self._custom_fields_diff[name].inspect}" # DEBUG

      operations = self._custom_fields_diff[name]
      operations['$set'].merge!({ 'custom_fields_recipe.version' => self.custom_fields_version(name) })
      collection, selector = self.send(name).collection, self.send(name).criteria.selector

      # puts "selector = #{selector.inspect}, memo = #{attributes.inspect}" # DEBUG
      collection.find(selector).update(operations)
    end


    module ClassMethods

      # Determines if the relation is enhanced by the custom fields
      #
      # @example the Person class has somewhere in its code this: "custom_fields_for :addresses"
      #   Person.custom_fields_for?(:addresses)
      #
      # @param [ String, Symbol ] name The name of the relation.
      #
      # @return [ true, false ] True if enhanced, false if not.
      #
      def custom_fields_for?(name)
        self._custom_fields_for.include?(name.to_s)
      end

      # Determines if the relation is enhanced by the custom fields
      #
      # @example the Person class has somewhere in its code this: "custom_fields_for :addresses"
      #   Person.embedded_fields_for?(:addresses)
      #
      # @param [ String, Symbol ] name The name of the relation.
      #
      # @return [ true, false ] True if enhanced, false if not.
      #
      def embedded_fields_for?(name)
        return unless name.to_s.include?("_custom_fields")
        name = name.to_s.split('_custom_fields').first
        self.custom_fields_for?(name)
      end

      # Enhance a referenced collection OR the instance itself (by passing self) by providing methods to manage custom fields.
      #
      # @param [ String, Symbol ] name The name of the relation.
      #
      # @example
      #   class Company
      #     embeds_many :employees
      #     custom_fields_for :employees
      #   end
      #
      #   class Employee
      #     embedded_in :company, :inverse_of => :employees
      #     field :name, String
      #   end
      #
      #   company.employees_custom_fields.build :label => 'His/her position', :name => 'position', :kind => 'string'
      #   company.save
      #   company.employees.build :name => 'Michael Scott', :position => 'Regional manager'
      #
      def custom_fields_for(name)
        self.declare_embedded_in_definition_in_custom_field(name)

        # stores the relation name
        self._custom_fields_for << name.to_s

        self.extend_for_custom_fields(name)
      end

      # Returns the class name of the custom field which is based both on the parent class name
      # and the name of the relation in order to avoid name conflicts (with other classes)
      #
      # @param [ String, Symbol ] metadata The field klass
      #
      # @return [ String ] The class name
      def field_klass_with_custom_fields(type)
        "CustomFields::Fields::#{type.to_s.classify}::Field"
      end

      protected

      # Extends / Decorates the current class in order to be fully custom_fields compliant.
      # it declares news fields, adds new callbacks, ...etc
      #
      # @param [ String, Symbol ] name The name of the relation.
      #
      def extend_for_custom_fields(name)
        class_eval do
          field :"#{name}_custom_fields_version",
            :type => Integer,
            :default => 0

          embeds_many :"#{name}_custom_fields",
            :class_name => self.custom_field_klass.name

          accepts_nested_attributes_for :"#{name}_custom_fields",
            :allow_destroy => true
        end

        class_eval <<-EOV, __FILE__, __LINE__ + 1
          after_initialize  :refresh_#{name}_metadata
          before_update     :bump_#{name}_custom_fields_version
          before_update     :collect_#{name}_custom_fields_diff
          after_update      :apply_#{name}_custom_fields_diff

          def ordered_#{name}_custom_fields
            self.ordered_custom_fields('#{name}')
          end

          protected

          def refresh_#{name}_metadata
            self.refresh_metadata_with_custom_fields('#{name}')
          end

          def bump_#{name}_custom_fields_version
            self.bump_custom_fields_version('#{name}')
          end

          def collect_#{name}_custom_fields_diff
            self.collect_custom_fields_diff(:#{name}, self.#{name}_custom_fields)
          end

          def apply_#{name}_custom_fields_diff
            self.apply_custom_fields_diff(:#{name})
          end

        EOV
      end

      # Returns the class name of the custom field which is based both on the parent class name
      # and the name of the relation in order to avoid name conflicts (with other classes)
      #
      # @param [ Metadata ] metadata The relation's old metadata.
      #
      # @return [ String ] The class name
      #
      def custom_field_klass
        self.field_klass_with_custom_fields("default").constantize
      end

      # Returns the relation name of the custom field
      #
      # @param [ String, Symbol ] name The name of the relation.
      #
      # @return [ String ] The relation name
      #
      def embedded_fields_relation_name(name)
        "#{name}_custom_fields"
      end

      # An embedded relationship has to be defined on both side in order for it
      # to work properly. But because custom_field can be embedded in different
      # models that it's not aware of, we have to declare manually the definition
      # once we know the target class.
      #
      # @param [ String, Symbol ] name The name of the relation.
      #
      # @return [ Field ] The new field class.
      #
      def declare_embedded_in_definition_in_custom_field(name)
        custom_field_klass.embedded_in :"#{self.name.demodulize.underscore}",
          :inverse_of => self.embedded_fields_relation_name(name).to_sym,
          :class_name => self.name
      end

    end

  end

end
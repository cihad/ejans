module Fields
  class TagFieldConfiguration < FieldConfiguration
    include Ejans::Fields::Filterable

    def filter_query(params = {})
      if params[machine_name].present?
        tags = params[machine_name].split(',').map(&:strip)
        NodeQuery.new.all(keyname => tags)
      else
        NodeQuery.new
      end
    end

    def set_specifies
      node_klass.instance_eval <<-EOM
        field :#{keyname}, type: Array, default: []

        validate :#{keyname}_presence_value
      EOM

      node_klass.class_eval <<-EOM
        def #{machine_name}
          #{keyname}
        end
        
        def #{keyname}_tags=(tags)
          self.#{keyname} = tags.split(',').map(&:strip)
        end

        def #{keyname}_tags
          self.#{keyname}.try(:join, ', ')
        end

        private
        def #{keyname}_presence_value
          if #{required?} and #{keyname}.size == 0
            errors.add(:#{keyname}, "alaninda en az bir tag girmelisiniz.")
          end
        end
      EOM
    end
  end
end
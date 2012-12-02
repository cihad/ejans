module Fields
  class StringFieldConfiguration < FieldConfiguration
    include Ejans::Fields::Sortable

    field :row, type: Integer, default: 1

    field :text_format, type: Symbol
    TEXT_FORMATS = [:plain, :simple, :extended]    
    validates :text_format, inclusion: { in: TEXT_FORMATS }
    
    def set_specifies
      node_klass.instance_eval <<-EOM
        field :#{keyname}, as: :#{machine_name}, type: String

        validate :#{keyname}_presence_value
      EOM

      node_klass.class_eval <<-EOM        
        private
        def #{keyname}_presence_value
          if #{required?} and #{keyname}.blank?
            errors.add(:#{keyname}, "bos birakilamaz.")
          end
        end
      EOM
    end

    def fill_node_with_random_value(node)
      node.send("#{machine_name}=", Faker::Lorem.sentences.join(' '))
    end
  end
end
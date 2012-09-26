module Fields
  class StringFieldConfiguration < FieldConfiguration
    include Ejans::Fields::Sortable

    field :row, type: Integer, default: 1
    field :minimum_length, type: Integer
    field :maximum_length, type: Integer

    field :text_format, type: Symbol
    TEXT_FORMATS = [:plain, :simple, :extended]    
    validates :text_format, inclusion: { in: TEXT_FORMATS }
    
    def set_specifies
      Node.instance_eval <<-EOM
        field #{keyname}, type: String

        validate :#{keyname}_presence_value
        validate :#{keyname}_not_greater_than_maximum_length
        validate :#{keyname}_not_less_than_minimum_length
      EOM

      Node.class_eval <<-EOM
        def #{machine_name}
          #{keyname}
        end
        
        private
        def #{keyname}_presence_value
          if #{required?} and #{keyname}.blank?
            errors.add(:#{keyname}, "bos birakilamaz.")
          end
        end

        def not_less_than_minimum_length
          if #{keyname} and #{min} and #{keyname}.size < #{min}
            errors.add(:#{keyname}, "#{min} degerinden kucuk olamaz.")
          end
        end

        def not_greater_than_maximum_length
          if #{keyname} and #{max} and #{keyname}.size > #{max}
            errors.add(:#{keyname}, "#{max} degerinden buyuk olamaz.")
          end
        end
      EOM
    end
  end
end
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
      node_klass.instance_eval <<-EOM
        include ActionView::Helpers::TextHelper
        include ActionView::Helpers::SanitizeHelper
        field :#{keyname}, type: String

        validate :#{keyname}_presence_value
        validate :#{keyname}_not_greater_than_maximum_length
        validate :#{keyname}_not_less_than_minimum_length
      EOM

      node_klass.class_eval <<-EOM
        def #{machine_name}
          begin
            sanitize(simple_format(#{keyname}), tags: %w(p img br strong b i em a ul ol li blockquote))
          rescue
            nil
          end
        end
        
        private
        def #{keyname}_presence_value
          if #{required?} and #{keyname}.blank?
            errors.add(:#{keyname}, "bos birakilamaz.")
          end
        end

        def #{keyname}_not_less_than_minimum_length
          if  #{keyname} and
              #{minimum_length || false} and
              #{keyname}.size < #{minimum_length || 0}
            errors.add(:#{keyname}, "#{minimum_length} degerinden kucuk olamaz.")
          end
        end

        def #{keyname}_not_greater_than_maximum_length
          if  #{keyname} and
              #{maximum_length || false} and
              #{keyname}.size > #{maximum_length || 0}
            errors.add(:#{keyname}, "#{maximum_length} degerinden buyuk olamaz.")
          end
        end
      EOM
    end
  end
end
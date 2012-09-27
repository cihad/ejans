module Fields
  class ListFieldConfiguration < FieldConfiguration
    include Ejans::Fields::Filterable

    field :maximum_select, type: Integer, default: 0
    validates :maximum_select, presence: true

    has_and_belongs_to_many :list_items, class_name: "Fields::ListItem"
    accepts_nested_attributes_for :list_items,
      reject_if: ->(attrs){ attrs[:name].blank? }

    def filter_query(params = {})
      if params[machine_name].present?
        list_item_ids = Fields::ListItem.find(params[machine_name]).map(&:id)
        NodeQuery.new.in(:"#{where}" => list_item_ids)
      else
        NodeQuery.new
      end
    end

    def set_specifies
      Node.instance_eval <<-EOM
        has_and_belongs_to_many :#{keyname}, class_name: "Fields::ListItem"

        validate :#{keyname}_presence_value
        validate :#{keyname}_selected_item_count
      EOM

      Node.class_eval <<-EOM
        def #{machine_name}
          #{keyname}
        end
        
        private
        def #{keyname}_presence_value
          if #{required?} and #{keyname}.size == 0
            erros.add(:#{keyname}, "alani bos birakilamaz.")
          end
        end

        def #{keyname}_selected_item_count
          if #{maximum_select || false} and #{keyname}.size > #{maximum_select || 0}
            errors.add(:#{keyname}, "en fazla #{maximum_select} parca secebilirsiniz.")
          end
        end
      EOM
    end

    private
    
    def where
      "#{keyname.to_s.singularize}_ids"
    end

    def assign_keyname
      name_prefix = 0
      while keynames.include?(name = "#{I18n.with_locale(:en) { name_prefix.to_words }}_list_items".to_sym)
        name_prefix = name_prefix.next
      end
      name
    end
  end
end
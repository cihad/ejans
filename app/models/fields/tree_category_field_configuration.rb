module Fields
  class TreeCategoryFieldConfiguration < FieldConfiguration
    include Ejans::Fields::Filterable

    belongs_to :category
    validates :category, presence: true

    def category_levels
      unless @category_levels
        @category_levels = category.levels
        @category_levels.shift
      end
      @category_levels
    end

    def level_size
      category_levels.size
    end

    def form_machine_names
      1.upto(level_size).map { |l| "#{machine_name}_level_#{l}" }
    end

    def filter_query(params = {})
      category.levels.size.times do |i|
        prm = params[form_machine_names[-(i+1)]]
        if prm.present?
          category_id = Category.find(prm).id
          @criteria = BlankCriteria.new.in(:"#{where}" => [category_id])
          break
        else
          @criteria = BlankCriteria.new
        end
      end
      @criteria
    end

    def set_specifies
      node_klass.instance_eval <<-EOM
        has_and_belongs_to_many :#{keyname},
                                class_name: "Category",
                                inverse_of: nil
        validate :#{keyname}_presence_value
      EOM

      node_klass.class_eval <<-EOM
        def #{machine_name}
          #{keyname}
        end
        
        private
        def #{keyname}_presence_value
          if #{required?} and #{keyname}.blank?
            errors.add(:#{keyname}, "bos birakilamaz.")
          end
        end
      EOM
    end

    private
    def where
      "#{keyname}_ids"
    end
  end
end
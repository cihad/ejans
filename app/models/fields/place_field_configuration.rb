module Fields
  class PlaceFieldConfiguration < FieldConfiguration
    include Ejans::Fields::Filterable

    field :level, type: Integer
    validates :level, numericality: { greater_than_or_equal_to: 1 }
    
    field :place_page_list, type: Boolean, default: false

    belongs_to :top_place, class_name: "Place"
    validates :top_place, presence: true

    after_save :create_place_view

    def level_names
      top_place.bottom_level_names.first(level+1)
    end

    def level_machine_names
      top_place.bottom_level_machine_names.first(level+1)
    end

    def form_level_names
      names = level_names
      names.shift
      names
    end

    def form_machine_names
      names = level_machine_names
      names.shift
      names.map { |name| "#{machine_name}_#{name}" }
    end

    def filter_query(params = {})
      level.times do |i|
        prm = params[form_machine_names[-(i+1)]]
        if prm.present?
          place_id = Place.find(prm).id
          @query = NodeQuery.new.in(:"#{where}" => [place_id])
          break
        else
          @query = NodeQuery.new
        end
      end
      @query
    end

    def set_specifies
      node_klass.instance_eval <<-EOM
        has_and_belongs_to_many :#{keyname}, class_name: "Place", inverse_of: nil

        validate :#{keyname}_presence_value
        validate :#{keyname}_out_level
      EOM

      node_klass.class_eval <<-EOM
        def #{machine_name}
          #{keyname}
        end
        
        private
        
        def #{keyname}_presence_value
          if #{required?} and #{keyname}.size != #{level}
            errors.add(:#{keyname}, "bos birakilamaz.")
          end
        end

        def #{keyname}_out_level
          unless #{keyname}_inheritance?
            errors.add(:#{keyname}, "agac yapida olmayan yerler var.")
          end
        end

        def #{keyname}_inheritance?
          true
        end
      EOM
    end

    private
    def where
      "#{keyname}_ids"
    end

    def create_place_view
      if place_page_list and node_type.place_page_view.blank?
        node_type.build_place_page_view().save(validate: false)
      elsif place_page_list_changed? and !place_page_list
        node_type.place_page_view.try(:destroy)
      end
    end
  end
end
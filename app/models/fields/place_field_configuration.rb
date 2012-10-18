module Fields
  class PlaceFieldConfiguration < FieldConfiguration
    include Ejans::Fields::Filterable

    field :level, type: Integer
    validates :level, numericality: { greater_than_or_equal_to: 1 }
    
    field :place_page_list, type: Boolean, default: false
    field :multiselect, type: Boolean, default: false

    belongs_to :top_place, class_name: "Place"
    validates :top_place, presence: true

    after_save :create_place_view

    def top_place_name
      top_place.try(:hierarchical_name)
    end

    def top_place_name=(name)
      self.top_place = ::Place.find_by(name: name.split(">").map(&:strip)[-1]) if name.present?
    end

    def form_machine_names
      level.times.map { |i| "#{machine_name}_#{i}" }
    end

    def filter_query(params = {})
      level.times do |i|
        prm = params[form_machine_names[-(i+1)]]
        if prm.present?
          place_id = Moped::BSON::ObjectId(prm)
          @query = NodeQuery.new.in(where => [place_id])
          break
        else
          @query = NodeQuery.new
        end
      end
      @query
    end

    def set_specifies
      node_klass.instance_eval <<-EOM
        embeds_many :#{keyname}, class_name: "Fields::Place"
        accepts_nested_attributes_for :#{keyname},
          allow_destroy: true

        before_validation do
          #{keyname}.each do |place|
            place.delete if place.place_ids.size == 0
          end
        end

        validate :#{keyname}_presence_value
        validate :#{keyname}_out_level
      EOM

      node_klass.class_eval <<-EOM
        def #{machine_name}
          begin
            #{keyname}.unscoped
          rescue
            []
          end
        end
        
        private
        
        def #{keyname}_presence_value
          if #{required?} and #{keyname}.size == 0
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
      :"#{keyname}.place_ids"
    end

    def create_place_view
      if place_page_list and node_type.place_page_view.blank?
        node_type.build_place_page_view().save(validate: false)
      elsif place_page_list_changed? and !place_page_list
        node_type.place_page_view.try(:destroy)
      end
    end

    def assign_keyname
      name_prefix = 0
      while keynames.include?(name = "#{I18n.with_locale(:en) { name_prefix.to_words }}_places".to_sym)
        name_prefix = name_prefix.next
      end
      name
    end
  end
end
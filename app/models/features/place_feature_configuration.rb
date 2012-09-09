module Features
  class PlaceFeatureConfiguration < FeatureConfiguration
    include Ejans::Features::Filterable

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

    def data_for_node
      super.merge({
        :"#{machine_name}_level" => level,
        :"#{machine_name}_top_place_name" => top_place.try(:name)
      })
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

    private
    def where
      "features." +
      "#{key_name}_ids"
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
module Features
  class PlaceFeatureConfiguration < FeatureConfiguration
    include Mongoid::Document
    include Ejans::Features::Filterable

    field :level, type: Integer
    belongs_to :top_place, class_name: "Place"

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
  end
end
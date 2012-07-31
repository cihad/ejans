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

    def filter_query(params = {})
      level.times do |i|
        prm = params[form_machine_names[-(i+1)]]
        if prm.present?
          place_id = Place.find(prm).id
          @query = NodeQuery.new.in(:"#{where}" => [place_id]).selector
          break
        else
          @query = {}
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
module Features
  class PlaceFeatureConfiguration
    include Mongoid::Document
    include Ejans::Features::FeatureConfigurationAbility
    include Ejans::Features::SingleValueFeatureConfiguration

    # Fields
    field :level, type: Integer

    # Associations
    embedded_in :feature_configuration, class_name: "Features::FeatureConfiguration"
    belongs_to :top_place, class_name: "Place"

    def build_assoc!(node)
      if node.features.map(&:feature_configuration).include?(parent)
        feature = node.features.where(feature_configuration_id: parent.id.to_s).first
      else
        feature = node.features.build
        feature.feature_configuration = parent
        feature.send("build_#{feature_type}")
      end

      feature.child.class.add_value(value_name)
    end

    def level_names
      top_place.bottom_level_names
    end

    def level_machine_names
      top_place.bottom_level_machine_names
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

    # Object Methods
    def type
      "City"
    end

    def filterable?
      true
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
      where = "features."
      where += "#{parent.feature_type}."
      where += "#{parent.value_name}_ids"
      where
    end
  end
end
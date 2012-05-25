module Features
  class StringFeatureConfiguration
    include Mongoid::Document
    field :row, type: Integer, default: 1
    field :maximum_length, type: Integer
    field :minumum_length, type: Integer
    field :default_value, type: String
    embedded_in :feature_configuration, class_name: "Features::FeatureConfiguration"

    def type
      "String"
    end
    
    def filterable?
      false
    end
  end
end
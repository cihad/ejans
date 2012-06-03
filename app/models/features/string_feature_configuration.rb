module Features
  class StringFeatureConfiguration
    include Mongoid::Document

    # Fields
    field :row, type: Integer, default: 1
    field :maximum_length, type: Integer
    field :minumum_length, type: Integer
    field :default_value, type: String
    field :filter_type, type: Symbol

    FILTER_TYPES = [:plain,
                    :simple,
                    :extended]
    # Plain
    # converts one line break to br, more line break to p,
    # urls and emails to link

    # Simple
    # allowed "br, p, a, strong, i" html tags

    # Extended
    # allowed more tags

    # Associations
    embedded_in :feature_configuration, class_name: "Features::FeatureConfiguration"

    # Methods
    def type
      "String"
    end
    
    def filterable?
      false
    end
  end
end
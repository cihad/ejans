module Features
  class StringFeatureConfiguration < FeatureConfiguration
    include Ejans::Features::Sortable

    field :row, type: Integer, default: 1
    field :minimum_length, type: Integer
    field :maximum_length, type: Integer

    field :text_format, type: Symbol
    TEXT_FORMATS = [:plain, :simple, :extended]    
    validates :text_format, inclusion: { in: TEXT_FORMATS }

    def data_names
      super + [:"#{machine_name}_value"]
    end
  end
end
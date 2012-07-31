module Features
  class StringFeatureConfiguration < FeatureConfiguration
    include Mongoid::Document

    TEXT_FORMATS = [:plain, :simple, :extended]    
    field :row, type: Integer, default: 1
    field :minimum_length, type: Integer
    field :maximum_length, type: Integer
    field :text_format, type: Symbol

    validates :text_format, inclusion: { in: TEXT_FORMATS }
  end
end
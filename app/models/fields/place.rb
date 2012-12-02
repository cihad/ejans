module Fields
  class Place
    include Mongoid::Document
    embedded_in :node
    has_and_belongs_to_many :places, class_name: "::Place"
    accepts_nested_attributes_for :places
  end
end
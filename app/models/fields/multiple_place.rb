module Fields
  class MultiplePlace
    include Mongoid::Document
    embedded_in :node
    has_and_belongs_to_many :places
    accepts_nested_attributes_for :places
  end
end
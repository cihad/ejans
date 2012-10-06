module Fields
  class MultiplePlace
    include Mongoid::Document
    has_and_belongs_to_many :places
  end
end
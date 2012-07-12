class Location
  include Mongoid::Document

  # Fields
  field :location, type: Array

  # Associations
  embedded_in :locationable, polymorphic: true

end
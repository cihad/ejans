class Location
  include Mongoid::Document

  # Fields
  field :location, type: Array

  # Associations
  embeedded_in :locationable, polymorphic: true

end
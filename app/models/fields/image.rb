module Fields
  class Image
    include Mongoid::Document
    # Fields
    mount_uploader :image, FieldImageUploader
    field :position, type: Integer, default: 1000
    embedded_in :imageable, polymorphic: true

    default_scope order_by([:position, :asc])
  end
end
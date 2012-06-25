module Features
  class Image
    include Mongoid::Document
    # Fields
    mount_uploader :image, FeatureImageUploader
    field :position, type: Integer
    belongs_to :node, inverse_of: nil

    default_scope order_by([:position, :asc])
  end
end
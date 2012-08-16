module Features
  class Image
    include Mongoid::Document
    # Fields
    mount_uploader :image, FeatureImageUploader
    field :position, type: Integer
    embedded_in :feature, class_name: "Features::ImageFeature"

    default_scope order_by([:position, :asc])
  end
end
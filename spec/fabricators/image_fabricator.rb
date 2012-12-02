DIR = "#{Rails.root}/spec/support/images"
IMAGE = "#{DIR}/image-800-600.jpg"

Fabricator :image_800_600, class_name: "Fields::Image" do
  image File.new(IMAGE)
end
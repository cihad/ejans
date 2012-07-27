Fabricator :image_fc, from: :conf, class_name: "Features::ImageFeatureConfiguration" do
  maximum_image 10
end

Fabricator :image_feature, class_name: "Features::ImageFeature" do
end

Fabricator :fotograflar_fc, from: :conf, class_name: "Features::FeatureConfiguration" do
  maximum_image 20
end
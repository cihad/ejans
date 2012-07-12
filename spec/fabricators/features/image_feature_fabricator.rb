Fabricator :fotograflar_fc, class_name: "Features::FeatureConfiguration" do
  label     "Fotograflar"
  required  false
  help      { Faker::Lorem.sentence }

  after_build do |fotograflar_fc|
    fotograflar_fc.image_feature_configuration = Fabricate.build(:fotograflar_image_fc)
  end
end

Fabricator :fotograflar_image_fc, class_name: "Features::ImageFeatureConfiguration" do
  maximum_image 20
end
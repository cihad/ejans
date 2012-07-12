Fabricator :feature_configuration, class_name: "Features::FeatureConfiguration" do
  label { Faker::Lorem.words }
  required true
  help { Faker::Lorem.sentences }
  sort false
  filter false
end
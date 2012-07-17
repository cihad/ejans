Fabricator :place_fc, class_name: "Features::PlaceFeatureConfiguration" do
  level 3

  after_build do |place_fc|
    place_fc.top_place = Fabricate.build(:place)
  end
end

Fabricator :mahalle_fc, class_name: "Features::FeatureConfiguration" do
  label "Mahalle"
  required true
  help { Faker::Lorem.sentence }
  filter true

  after_build do |mahalle_fc|
    mahalle_fc.place_feature_configuration = Fabricate.build(:mahalle_place_fc)
  end
end

Fabricator :mahalle_place_fc, class_name: "Features::PlaceFeatureConfiguration" do
  level 3

  after_build do |mahalle_place_fc|
    mahalle_place_fc.top_place = Fabricate.build(:turkiye)
  end
end
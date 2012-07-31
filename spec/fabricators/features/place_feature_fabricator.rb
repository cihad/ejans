Fabricator :place_fc, from: :conf, class_name: "Features::PlaceFeatureConfiguration" do
  filter false
  level 2
end

Fabricator :mahalle_fc, from: :conf, class_name: "Features::PlaceFeatureConfiguration" do
  filter false
  level 3
  
  after_build do |mahalle_place_fc|
    mahalle_place_fc.top_place = Fabricate.build(:turkiye)
  end
end
Fabricator :aciklama_fc, class_name: "Features::FeatureConfiguration" do
  label     "Aciklama"
  required  true
  help      "Lutfen anlasilir ve sade bir aciklama girin"

  after_build do |aciklama_fc|
    aciklama_fc.string_feature_configuration = Fabricate.build(:aciklama_string_fc)
  end
end

Fabricator :aciklama_string_fc, class_name: "Features::StringFeatureConfiguration" do
  row 5
  filter_type :plain
end

Fabricator :adres_fc, class_name: "Features::FeatureConfiguration" do
  label     "Adres"
  required  true
  help      { Faker::Lorem.sentence }

  after_build do |adres_fc|
    adres_fc.string_feature_configuration = Fabricate.build(:adres_string_fc)
  end
end

Fabricator :adres_string_fc, class_name: "Features::StringFeatureConfiguration" do
  row 2
  filter_type :plain
end
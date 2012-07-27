Fabricator :string_fc, from: :conf, class_name: "Features::StringFeatureConfiguration" do
  row 2
  minimum_length 100
  maximum_length 1_000
  text_format :plain
end

Fabricator :aciklama_fc, from: :conf, class_name: "Features::StringFeatureConfiguration" do
  row 5
  filter_type :plain
end

Fabricator :adres_fc, from: :conf, class_name: "Features::StringFeatureConfiguration" do
  row 2
  filter_type :plain
end
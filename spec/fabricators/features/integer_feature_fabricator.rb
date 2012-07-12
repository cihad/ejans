Fabricator :integer_feature_configuration, class_name: "Features::IntegerFeatureConfiguration" do
  minumum 0
  maximum 1_000_000
  filter_type :number_field
  locale :tr
  significant true
  view_type :number_to_currency
  precision 3
  unit "$"
  units :distance
  separator ","
  delimiter "."
  prefix "prefix"
  area_code true
  country_code 1
end

Fabricator :fiyat_fc, class_name: "Features::FeatureConfiguration" do
  label "Fiyat"
  required true
  help { Faker::Lorem.paragraph }
  sort true
  filter true

  after_build do |fiyat_fc|
    fiyat_fc.integer_feature_configuration = Fabricate.build(:fiyat_integer_fc)
  end
end

Fabricator :fiyat_integer_fc, class_name: "Features::IntegerFeatureConfiguration" do
  minumum 0
  filter_type :range_with_number_field
  locale :tr
  view_type :number_to_currency
  precision 0
  delimiter "."
end

Fabricator :metrekare_fc, class_name: "Features::FeatureConfiguration" do
  label "Metrekare"
  required true
  help { Faker::Lorem.sentence }
  sort true
  filter true

  after_build do |metrekare_fc|
    metrekare_fc.integer_feature_configuration = Fabricate.build(:metrekare_integer_fc)
  end
end

Fabricator :metrekare_integer_fc, class_name: "Features::IntegerFeatureConfiguration" do
  minumum 0
  view_type :number_with_delimiter
end
Fabricator :integer_fc, from: :conf, class_name: "Features::IntegerFeatureConfiguration" do
  filter_type :number_field
  minumum 0
  maximum 1_000_000
  prefix "text for prefix"
  suffix "text for suffix"
  thousand_marker :none
end

Fabricator :fiyat_fc, from: :conf, class_name: "Features::FeatureConfiguration" do
  minumum 0
  filter_type :range_with_number_field
  locale :tr
  view_type :number_to_currency
  precision 0
  delimiter "."
end

Fabricator :metrekare_fc, from: :conf, class_name: "Features::FeatureConfiguration" do
  minumum 0
  view_type :number_with_delimiter
end
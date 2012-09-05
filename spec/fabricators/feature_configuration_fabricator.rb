Fabricator :conf, class_name: "Features::FeatureConfiguration" do
  label { sequence(:label) { |i| "Label #{i}" } }
  required true
  help_text "Help text"
end
Fabricator :date_fc, from: :conf, class_name: "Features::DateFeatureConfiguration" do
  date_type :year
  filter_type :single
  start_date_type :x_years_ago_start
  x_years_ago_start 50
  spesific_start_date Date.new(1950)
  end_date_type :x_years_ago_end
  x_years_ago_end 10
  x_years_later_end 10
  spesific_end_date Date.new(2023)
end
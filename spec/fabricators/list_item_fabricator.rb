Fabricator :list_item, class_name: "Features::ListItem" do
  name { sequence(:name) { |i| "Name #{i}" } }
end

Fabricator :bir_arti_bir, class_name: "Features::ListItem" do
  name "1+1"
end

Fabricator :iki_arti_bir, class_name: "Features::ListItem" do
  name "2+1"
end

Fabricator :uc_arti_bir, class_name: "Features::ListItem" do
  name "3+1"
end

Fabricator :studyo, class_name: "Features::ListItem" do
  name "Studyo"
end
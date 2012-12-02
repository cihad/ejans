Fabricator :place do
  name { Faker::Address.city }
end

Fabricator :world, class_name: "Place" do
  name "World"

  after_build do |world|
    world.children.push([
      Fabricate.build(:country),
      Fabricate.build(:country)
    ])
  end
end

Fabricator :country, class_name: "Place" do
  name { Faker::Address.country }

  after_build do |country|
    country.children.push([
      Fabricate.build(:city),
      Fabricate.build(:city)
    ])
  end
end

Fabricator :city, class_name: "Place" do
  name { Faker::Address.city }

  after_build do |city|
    city.children.push([
      Fabricate.build(:street),
      Fabricate.build(:street)
    ])
  end
end

Fabricator :street, class_name: "Place" do
  name { Faker::Address.street_name }
end
Fabricator :category do
  name { Faker::Lorem.word }

  after_build do |c|
    c.children.push([
      Fabricate(:child_level_category),
      Fabricate(:child_level_category),
    ])
  end
end

Fabricator :child_level_category, class_name: "Category" do
  name { Faker::Lorem.word }

  after_build do |c|
    c.children.push([
      Fabricate(:descendant_level_category),
      Fabricate(:descendant_level_category),
    ])
  end
end

Fabricator :descendant_level_category, class_name: "Category" do
  name { Faker::Lorem.word }
end
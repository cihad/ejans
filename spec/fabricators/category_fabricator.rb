Fabricator :category do
  name { Faker::Lorem.word }

  after_build do |c|
    c.children.push([
      Fabricate(:child_level),
      Fabricate(:child_level),
    ])
  end
end

Fabricator :child_level, class_name: "Category" do
  name { Faker::Lorem.word }

  after_build do |c|
    c.children.push([
      Fabricate(:descendant_level),
      Fabricate(:descendant_level),
    ])
  end
end

Fabricator :descendant_level, class_name: "Category" do
  name { Faker::Lorem.word }
end
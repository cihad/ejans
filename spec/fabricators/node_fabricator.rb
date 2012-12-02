Fabricator :node do
  title { Faker::Name.title }
  author { Fabricate(:user) }
end

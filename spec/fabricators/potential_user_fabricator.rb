Fabricator :potential_user do
  email { Faker::Internet.email }
  tags { Faker::Lorem.words.join(',') }
end
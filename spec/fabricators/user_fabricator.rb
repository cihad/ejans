Fabricator :anonymous_user, class_name: "User" do
  email { Faker::Internet.email }
  password "123456"
end

Fabricator :unconfirmed_user, from: :anonymous_user do
  role "registered"
end

Fabricator :user, from: :unconfirmed_user do
  after_create do |u| u.confirm! end
end

Fabricator :admin, from: :user do
  after_create do |u| u.admin! end
end

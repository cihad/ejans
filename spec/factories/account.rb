FactoryGirl.define do
  factory :account do 
    sequence(:email) {|n| "email#{n}@example.com" }
    password "secret"
    password_confirmation "secret"
  end
end
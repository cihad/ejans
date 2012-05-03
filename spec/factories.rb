FactoryGirl.define do
  factory :account do 
    sequence(:email) {|n| "email#{n}@example.com" }
    password "secret"
    password_confirmation "secret"
  end

  factory :service do
    title "Service Title"
    description "Lorem ipsum dolor sit amet."
    association :owner, factory: :account
  end

  factory :subscription do
    account
    service
  end

  factory :notification do
    title "Notification Title"
    sms "Notification Sms"
    description "Notification Description"
    association :notificationable, factory: :account
  end

  factory :notice do
    notification
    after_create { |notice| FactoryGirl.create(:subscription, notices: [notice]) }
  end

  factory :comment do
    body "Comment body"
    association :author, factory: :account
    notification
  end
end
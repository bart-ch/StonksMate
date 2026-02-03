FactoryBot.define do
  factory :user, class: "Users::User" do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
  end
end

require 'faker'

FactoryGirl.define do
  factory :customer, class: Breeze::Commerce::Customer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    # sequence(:email) { |n| "johndoe#{n}@example.com"}
    email { Faker::Internet.email }
    password 'logmein'
    password_confirmation 'logmein'
  end
end
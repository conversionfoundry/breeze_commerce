require 'faker'

FactoryGirl.define do
  factory :admin, class: Breeze::Admin::User do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    # sequence(:email) { |n| "johndoe#{n}@example.com"}
    email { Faker::Internet.email }
    password 'logmein'
    password_confirmation 'logmein'
    roles [:admin]
  end

  factory :merchant, class: Breeze::Admin::User do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    # sequence(:email) { |n| "johndoe#{n}@example.com"}
    email { Faker::Internet.email }
    password 'logmein'
    password_confirmation 'logmein'
    roles [:merchant]
  end

  factory :nonmerchant, class: Breeze::Admin::User do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    # sequence(:email) { |n| "johndoe#{n}@example.com"}
    email { Faker::Internet.email }
    password 'logmein'
    password_confirmation 'logmein'
    roles [:admin, :editor]
  end
end
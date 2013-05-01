require 'faker'

FactoryGirl.define do
  factory :customer, class: Breeze::Commerce::Customer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password 'logmein'
    password_confirmation 'logmein'
  end

  factory :different_customer, class: Breeze::Commerce::Customer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password 'logmein'
    password_confirmation 'logmein'
  end
end
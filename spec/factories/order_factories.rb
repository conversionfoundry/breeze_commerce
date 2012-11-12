require 'faker'

FactoryGirl.define do
  factory :order, class: Breeze::Commerce::Order do
    email { Faker::Internet.email }
  end
end
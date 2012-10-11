require 'faker'

FactoryGirl.define do
  factory :order, class: Breeze::Commerce::Order do
    store { Breeze::Commerce::Store.first } # This doesn't work!
    email { Faker::Internet.email }
  end
end
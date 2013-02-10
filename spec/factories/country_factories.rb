require 'faker'

FactoryGirl.define do
  factory :country, class: Breeze::Commerce::Country do
    name { Faker::Address.country }
    shipping_methods {[FactoryGirl.create(:shipping_method)]}
  end
end
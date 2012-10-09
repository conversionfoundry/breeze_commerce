require 'faker'

FactoryGirl.define do
  factory :shipping_method, class: Breeze::Commerce::ShippingMethod do
  	store { Breeze::Commerce::Store.first }
    sequence(:name) { |n| "Shipping Method #{n}"}
    sequence(:description) { |n| "Description for Shipping Method #{n}"}
    price_cents { Random.rand(1000) }
  end
end
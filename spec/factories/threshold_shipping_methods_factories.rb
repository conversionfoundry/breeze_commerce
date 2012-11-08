require 'faker'

FactoryGirl.define do
  factory :threshold_shipping_method, class: Breeze::Commerce::ThresholdShippingMethod do
    sequence(:name) { |n| "Threshold Shipping Method #{n}"}
    sequence(:description) { |n| "Description for Threshold Shipping Method #{n}"}
    price_cents { Random.rand(1000) }
    threshold_cents { Random.rand(1000) }
    above_threshold_price_cents { Random.rand(1000) }
  end
end
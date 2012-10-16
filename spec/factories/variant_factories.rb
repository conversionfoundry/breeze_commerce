require 'faker'

FactoryGirl.define do
  factory :variant, class: Breeze::Commerce::Variant do
    product {FactoryGirl.create(:product)}
  	sequence(:name) { |n| "Variant #{n}"}
  	sequence(:sku_code) { |n| "VRN-#{n}"}
    cost_price_cents { Random.rand(1000) }
    sell_price_cents { cost_price_cents + Random.rand(1000) }
  end
end
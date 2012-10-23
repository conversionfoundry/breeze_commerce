require 'faker'

FactoryGirl.define do
  factory :product, class: Breeze::Commerce::Product do
  	store { Breeze::Commerce::Store.first }
    sequence(:title) { |n| "Product #{n}"}
    sequence(:slug) { |n| "product_#{n}"}
  	parent { Breeze::Content::Page.first || nil }
    # sequence(:description) { |n| "Description for Shipping Method #{n}"}
    # price_cents { Random.rand(1000) }
  end
end
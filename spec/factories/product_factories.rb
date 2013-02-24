require 'faker'

FactoryGirl.define do
  factory :product, class: Breeze::Commerce::Product do
    sequence(:title) { |n| "Product #{n}"}
    sequence(:slug) { |n| "product_#{n}"}
  	parent { Breeze::Content::Page.first || nil }
    # sequence(:description) { |n| "Description for Shipping Method #{n}"}
    # price_cents { Random.rand(1000) }
  end

  factory :birthday_cake, class: Breeze::Commerce::Product do
  	title "Birthday Cake"
  	slug "birthday_cake"
  	parent { Breeze::Content::Page.first || nil }
  	published true
  end
end
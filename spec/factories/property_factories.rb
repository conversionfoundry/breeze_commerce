require 'faker'

FactoryGirl.define do
  factory :property, class: Breeze::Commerce::Property do
    product_ids {[FactoryGirl.create(:product)]}
  	sequence(:name) { |n| "Option #{n}"}
  end
end
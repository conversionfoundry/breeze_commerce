require 'faker'

FactoryGirl.define do
  factory :product_relationship, class: Breeze::Commerce::ProductRelationship do
    parent_product {[FactoryGirl.create(:product)]}
    child_product {[FactoryGirl.create(:product)]}
    kind "is_related_to"
  end
end
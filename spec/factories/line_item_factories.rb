require 'faker'

FactoryGirl.define do

  factory :line_item, class: Breeze::Commerce::LineItem do
    order {FactoryGirl.create(:order)}
    variant {FactoryGirl.create(:variant)}
    quantity { Random.rand(100) }
  end

end
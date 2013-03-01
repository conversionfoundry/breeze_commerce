FactoryGirl.define do
  factory :promotion, class: Breeze::Commerce::Coupons::Promotion do
    sequence(:name) { |n| "Promotion #{n}"}
  end
end
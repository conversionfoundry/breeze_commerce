FactoryGirl.define do
  factory :coupon, class: Breeze::Commerce::Coupons::Coupon do
    sequence(:code) { |n| "XYZZY#{n}"}
    redemption_count 0
    max_redemptions 1
    promotion {FactoryGirl.create(:promotion)}
  end
end
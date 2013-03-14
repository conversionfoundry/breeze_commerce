FactoryGirl.define do
  factory :coupon_code, class: Breeze::Commerce::Coupons::CouponCode do
    sequence(:code) { |n| "XYZZY#{n}"}
    redemption_count 0
    max_redemptions 1
    coupon {FactoryGirl.create(:coupon)}
  end
end
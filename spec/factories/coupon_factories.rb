FactoryGirl.define do
  factory :coupon, class: Breeze::Commerce::Coupons::Coupon do
    sequence(:name) { |n| "Coupon #{n}"}
    start_time Time.now
    end_time Time.now
    discount_value 100
    discount_type :fixed
    couponable_type Breeze::Commerce::Order.name
  end

  factory :coupon_20_dollars_off_order, class: Breeze::Commerce::Coupons::Coupon do
    name "$20 off your whole order"
    start_time Time.now - 1.day
    end_time nil
    discount_value 2000
    discount_type :fixed
    couponable_type Breeze::Commerce::Order.name
  end

  factory :coupon_15_percent_off_order, class: Breeze::Commerce::Coupons::Coupon do
    name "$20 off your whole order"
    start_time Time.now - 1.day
    end_time nil
    discount_value 15
    discount_type :percentage
    couponable_type Breeze::Commerce::Order.name
  end

end

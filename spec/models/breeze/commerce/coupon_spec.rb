require 'spec_helper'

describe Breeze::Commerce::Coupons::Coupon do

  subject do 
    create(:coupon)
  end

  it "has a valid factory" do
    subject.should be_valid
  end

  describe "validation" do
    it "is invalid without a name" do
      build(:coupon, name: nil).should_not be_valid
    end
    it "is invalid without a start_time" do
      build(:coupon, start_time: nil).should_not be_valid
    end
    it "is valid without an end_time" do
      build(:coupon, end_time: nil).should be_valid
    end
    it "is invalid without a discount_value" do
      build(:coupon, discount_value: nil).should_not be_valid
    end
    it "is invalid without a discount_type" do
      build(:coupon, discount_type: nil).should_not be_valid
    end
    it "is invalid if discount_type is something other than :fixed or :percentage"
    it "is invalid without a couponable_type" do
      build(:coupon, couponable_type: nil).should_not be_valid
    end
  end

  describe "generating coupon_codes" do

    context "single-use coupon_codes" do
      before :each do
        subject.generate_coupon_codes(100, nil, 1)
      end
      it "can generate a single-use coupon_code" do
        subject.coupon_codes.length.should eq 100
      end
      it "has coupon_codes that can only be redeemed once" do
        subject.coupon_codes.first.max_redemptions.should eq 1
      end
      it "has an eight-digit unique code"
    end

    context "multi-use coupon_codes" do
      before :each do
        subject.generate_coupon_codes(1, "$1 off", 100)
      end
      it "can generate a multi-use coupon_code" do
        subject.coupon_codes.length.should eq 1
      end
      it "has a coupon_code that can be redeemed multiple times" do
        subject.coupon_codes.first.max_redemptions.should eq 100
      end
    end
  end

  describe "calculating order discounts" do
    before :each do
      @order = create(:order)
    end
    it "can calculate a fixed discount for a given order" do
      coupon = create(:coupon_20_dollars_off_order)
      coupon.calculate_discount(@order).should eq 20
    end
    it "can calculate a percentage discount for a given order" do
      coupon = create(:coupon_15_percent_off_order)
      @order.stub(:item_total_cents){10000} 
      coupon.calculate_discount(@order).should eq 15
    end
  end

  describe "days_left" do
    it "has one day left if end date is today" do
      subject.end_time = Time.now
      subject.days_left.should eq 1
    end
    it "has two days left if end date is tomorrow" do
      subject.end_time = Time.now + 1.day
      subject.days_left.should eq 2
    end
  end

  describe "can_redeem?" do
    it "can't be redeemed if coupon hasn't started yet" do
      coupon = build(:coupon, start_time: Time.now + 1.year)
      coupon.can_redeem?.should eq false
    end
    it "can't be redeemed if coupon is finished" do
      coupon = build(:coupon, end_time: Time.now - 1.year)
      coupon.can_redeem?.should eq false
    end
    it "can be redeemed if within the coupon period" do
      coupon = build(:coupon, start_time: Time.now - 1.year, end_time: Time.now + 1.year)
      coupon.can_redeem?.should eq true
    end
    it "can't be redeemed if it's inactive"
  end

  describe "redemption_count" do
    before :each do
      subject.generate_coupon_codes(100, nil, 2)
      @coupon_code_1 =  subject.coupon_codes.first
      @coupon_code_2 =  subject.coupon_codes.last
    end
    it "is 0 if no coupon codes have been redeemed" do
      subject.redemption_count.should eq 0
    end
    it "is 1 when a coupon code has been redeemed once" do
      @coupon_code_1.stub(:redemption_count){1}
      subject.redemption_count.should eq 1
    end
    it "is 2 when a coupon code has been redeemed twice" do
      @coupon_code_1.stub(:redemption_count){2}
      subject.redemption_count.should eq 2
    end
    it "is 2 when two different coupon codes have each been redeemed once" do
      @coupon_code_1.stub(:redemption_count){1}
      @coupon_code_2.stub(:redemption_count){1}
      subject.redemption_count.should eq 2
    end
  end

end
require 'spec_helper'

describe Breeze::Commerce::Coupons::CouponCode do

  subject do
    create(:coupon_code)
  end

  it "has a valid factory" do
    create(:coupon_code).should be_valid
  end

  describe "validation" do
    it "is invalid without a coupon" do
      build(:coupon_code, coupon: nil).should_not be_valid
    end
    it "is invalid without a redemption_count" do
      build(:coupon_code, redemption_count: nil).should_not be_valid
    end
    it "is valid without a max_redemptions" do
      build(:coupon_code, max_redemptions: nil).should be_valid
    end
  end

  describe "generate_unique_code" do
    it "generates a valid code if none is given" do
      coupon_code = build(:coupon_code, code: nil)
      coupon_code.should be_valid
      coupon_code.code.should_not eq nil
    end
  end

  describe "redemption" do
    before :each do
      @order=create(:order)
      @coupon_code=create(:coupon_code)
    end
    it "can be redeemed against an order" do
      @coupon_code.redeem(@order)
      @coupon_code.redemption_count.should eq 1
    end
    it "can't be redeemed if can_redeem? is false" do
      @coupon_code.stub(:can_redeem?){false}
      @coupon_code.redeem(@order)
      @coupon_code.redemption_count.should eq 0
    end
  end

  describe "can_redeem?" do
    it "can't be redeemed more than max_redemptions" do
      coupon_code=build(:coupon_code, max_redemptions: 1, redemption_count: 1)
      coupon_code.can_redeem?.should eq false
    end
    it "can be redeemed up to max_redemptions" do
      coupon_code=build(:coupon_code, max_redemptions: 1, redemption_count: 0)
      coupon_code.can_redeem?.should eq true
    end
    it "can be redeemed if max_redemptions is nil" do
      coupon_code=build(:coupon_code, max_redemptions: nil, redemption_count: 1)
      coupon_code.can_redeem?.should eq true
    end
    it "can't be redeemed if its coupon can't be redeemed" do
      subject.coupon.stub(:can_redeem?){false}
      subject.can_redeem?.should eq false
    end
  end

end
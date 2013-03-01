require 'spec_helper'

describe Breeze::Commerce::Coupons::Coupon do

	subject do 
		create(:coupon)
	end

	it "has a valid factory" do
		create(:coupon).should be_valid
	end

	describe "validation" do
		it "is invalid without a code" do
			build(:coupon, code: nil).should_not be_valid
		end
		it "is invalid without a promotion" do
			build(:coupon, promotion: nil).should_not be_valid
		end
		it "is invalid without a redemption_count" do
			build(:coupon, redemption_count: nil).should_not be_valid
		end
		it "is invalid without a max_redemptions" do
			build(:coupon, max_redemptions: nil).should_not be_valid
		end
	end

	describe "redemption" do
		before :each do
			@order=create(:order)
			@coupon=create(:coupon)
		end
		it "can be redeemed against an order" do
			@coupon.redeem(@order)
			@coupon.redemption_count.should eq 1
			@order.coupon.should eq @coupon
		end
		it "can't be redeemed more than max_redemptions"
	end

	# it "is invalid without an amount"
	# it "can be fixed or percentage"
	
	# it "is invalid without a start date"
	# it "is valid with an end date"
	# it "is valid without an end date"
	# it "can show the number of days left before it ends"

	# it "can be published or unpublished"

	# it "can report how many times it's been redeemed"

	# it "has a type (multi-use or single-use)"

	# it "can report whether it's eligible for a given order"

	# # calculate discount for a given order
	# # can more than one coupon be applied to the same order?

	# context "multi-use" do
	# 	it "allows user to set a code"
	# 	it "is invalid without a code"
	# 	it "is invalid with more than one code"
	# end

	# context "single-use" do
	# 	it "can generate a given number of codes"
	# 	it "is invalid without a code"
	# 	it "is valid with more than one code"

	# 	it "can remember which codes have been used"
	# 	it "allows redemption of an unused code"
	# 	it "marks a code as used when it's redeemed"
	# 	it "doesn't allow redemption of a used code"
	# end

end
require 'spec_helper'

describe Breeze::Commerce::ThresholdShippingMethod do
	it "has a valid factory" do
		create(:threshold_shipping_method).should be_valid
	end
	it "is invalid without a name" do
		build(:threshold_shipping_method, name: nil).should_not be_valid
	end
	it "is invalid with a duplicate name" do
		create(:threshold_shipping_method, name: "Duplicate Shipping Method Name")
		build(:threshold_shipping_method, name: "Duplicate Shipping Method Name").should_not be_valid
	end
	it "is invalid without price_cents" do
		build(:threshold_shipping_method, price_cents: nil).should_not be_valid
	end
	it "ignores non-numerical price_cents" do
		build(:threshold_shipping_method, price_cents: 'Eleventy-twelve').price_cents.should eq 0
	end
	it "is valid with zero price_cents" do
		build(:threshold_shipping_method, price_cents: 0).should be_valid
	end
	it "is invalid without threshold_cents" do
		build(:threshold_shipping_method, threshold_cents: nil).should_not be_valid
	end
	it "ignores non-numerical threshold_cents" do
		build(:threshold_shipping_method, threshold_cents: 'Eleventy-twelve').threshold_cents.should eq 0
	end
	it "is invalid with zero threshold_cents" do
		build(:threshold_shipping_method, threshold_cents: 0).should_not be_valid
	end
	it "is invalid without above_threshold_price_cents" do
		build(:threshold_shipping_method, above_threshold_price_cents: nil).should_not be_valid
	end
	it "ignores non-numerical above_threshold_price_cents" do
		build(:threshold_shipping_method, above_threshold_price_cents: 'Eleventy-twelve').above_threshold_price_cents.should eq 0
	end
	it "is valid with zero above_threshold_price_cents" do
		build(:threshold_shipping_method, above_threshold_price_cents: 0).should be_valid
	end

	describe "price" do
		before :each do
			@threshold_shipping_method = create(	:threshold_shipping_method,
																							price_cents: 1000, 
																							threshold_cents: 10000, 
																							above_threshold_price_cents: 500)
		end			
		it "has normal price below the threshold" do
			@order = mock(:order, item_total: 90) # note dollars, not cents here
			@threshold_shipping_method.price(@order).should eq 10
		end
		it "has above-threshold price above the threshold" do			
			@order = mock(:order, item_total: 110) # note dollars, not cents here
			@threshold_shipping_method.price(@order).should eq 5
		end
		it "has above-threshold price when exactly at the threshold" do			
			@order = mock(:order, item_total: 100) # note dollars, not cents here
			@threshold_shipping_method.price(@order).should eq 5
		end		

		it "has normal price_cents below the threshold" do
			@order = mock(:order, item_total_cents: 9000) # note dollars, not cents here
			@threshold_shipping_method.price_cents(@order).should eq 1000
		end
		it "has above-threshold price_cents above the threshold" do			
			@order = mock(:order, item_total_cents: 11000) # note dollars, not cents here
			@threshold_shipping_method.price_cents(@order).should eq 500
		end
		it "has above-threshold price_cents when exactly at the threshold" do			
			@order = mock(:order, item_total_cents: 10000) # note dollars, not cents here
			@threshold_shipping_method.price_cents(@order).should eq 500
		end
	end

end
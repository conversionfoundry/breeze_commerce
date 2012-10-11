require 'spec_helper'

describe Breeze::Commerce::ShippingMethod do
	it "has a valid factory" do
		create(:shipping_method).should be_valid
	end
	it "is invalid without a name" do
		build(:shipping_method, name: nil).should_not be_valid
	end
	it "is invalid with a duplicate name" do
		create(:shipping_method, name: "Duplicate Shipping Method Name")
		build(:shipping_method, name: "Duplicate Shipping Method Name").should_not be_valid
	end
	it "is invalid without price_cents" do
		build(:shipping_method, price_cents: nil).should_not be_valid
	end
	it "ignores non-numerical price_cents" do
		build(:shipping_method, price_cents: 'Eleventy-twelve').price_cents.should eq 0
	end
	it "is valid with zero price_cents" do
		build(:shipping_method, price_cents: 0).should be_valid
	end
	it "is invalid without a store" do
		shipping_method = create :shipping_method
		shipping_method.store = nil
		shipping_method.should_not be_valid
	end
	it "is the default shipping method if it's the first created" do
		first_shipping_method = Breeze::Commerce::ShippingMethod.first || create(:shipping_method) # We might have a first shipping method already set up
		second_shipping_method = create(:shipping_method)
		first_shipping_method.is_default?.should eq true
		second_shipping_method.is_default?.should eq false
		Breeze::Commerce::ShippingMethod.default.should eq first_shipping_method
		Breeze::Commerce::ShippingMethod.default.should_not eq second_shipping_method
	end
	it "can be set as default shipping method" do
		first_shipping_method = Breeze::Commerce::ShippingMethod.first || create(:shipping_method) # We might have a first shipping method already set up
		second_shipping_method = create(:shipping_method)
		second_shipping_method.make_default
		second_shipping_method.is_default?.should eq true
		Breeze::Commerce::ShippingMethod.default.should_not eq first_shipping_method
		Breeze::Commerce::ShippingMethod.default.should eq second_shipping_method
	end
	it "assigns some other shipping method as the new default before it's archived"
	it "can set and retrieve a price" do
		shipping_method = create :shipping_method
		shipping_method.price = 5546
		shipping_method.price.should eq 5546		
	end

	describe "scopes" do
		before :each do
			@shipping_method_1 = create(:shipping_method)
			@shipping_method_2 = create(:shipping_method, archived: true)
		end			
		context "unarchived scope" do
			it "returns an array of unarchived shipping methods" do
				Breeze::Commerce::ShippingMethod.unarchived.to_a.should include @shipping_method_1
				Breeze::Commerce::ShippingMethod.unarchived.should_not include @shipping_method_2
			end
		end
		context "archived scope" do
			it "returns an array of archived shipping methods" do
				Breeze::Commerce::ShippingMethod.archived.to_a.should include @shipping_method_2
				Breeze::Commerce::ShippingMethod.archived.should_not include @shipping_method_1
			end
		end
	end
end
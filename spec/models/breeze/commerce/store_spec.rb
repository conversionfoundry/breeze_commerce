require 'spec_helper'

describe Breeze::Commerce::Store do
	it "has a valid factory" do
		create(:store).should be_valid
	end
	it "can set a default shipping method" do
		store = Breeze::Commerce::Store.first
		first_shipping_method = Breeze::Commerce::ShippingMethod.first
		second_shipping_method = create(:shipping_method)
		store.default_shipping_method = second_shipping_method
		store.default_shipping_method.should eq second_shipping_method
		store.default_shipping_method.should_not eq first_shipping_method
	end
end
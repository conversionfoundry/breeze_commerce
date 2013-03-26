require 'spec_helper'

describe Breeze::Commerce::Store do
	it "has a valid factory" do
		create(:store).should be_valid
	end
	it "can set a default shipping method" do
		store = Breeze::Commerce::Store.first
		first_shipping_method = Breeze::Commerce::Shipping::ShippingMethod.first
		second_shipping_method = create(:shipping_method)
		store.default_shipping_method = second_shipping_method
		store.default_shipping_method.should eq second_shipping_method
		store.default_shipping_method.should_not eq first_shipping_method
	end

	it "sets a default country if none is set and one is available" do
		store = Breeze::Commerce::Store.first
		first_country = create(:country)
		store.default_country.should eq first_country
	end

	it "can set a default country" do
		store = Breeze::Commerce::Store.first
		first_country = create(:country)
		second_country = create(:country)
		store.default_country = second_country
		store.default_country.should eq second_country
		store.default_country.should_not eq first_country
	end
end
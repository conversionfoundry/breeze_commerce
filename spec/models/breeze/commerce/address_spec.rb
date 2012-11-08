require 'spec_helper'

describe Breeze::Commerce::Address do
	it "has a valid factory" do
		customer = create(:customer, shipping_address: FactoryGirl.build(:address) )
		address = customer.shipping_address
		address.should be_valid
	end
end
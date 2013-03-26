require 'spec_helper'

describe Breeze::Commerce::Shipping::Country do
	it "has a valid factory" do
		create(:country).should be_valid
	end

	describe "validation" do
		it "is invalid with no name" do
			build(:country, name: nil).should_not be_valid
		end
		it "is invalid without a shipping method" do
			build(:country, shipping_methods: []).should_not be_valid
		end
	end
end
require 'spec_helper'

describe Breeze::Commerce::Country do
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

	it "sets the first shipping method as default if not given a default"
	it "gives an appropriate warning message if there are no shipping methods"

end
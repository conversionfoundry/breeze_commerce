require 'spec_helper'

describe Breeze::Commerce::Store do
	it "has a valid factory" do
		create(:store).should be_valid
	end
end
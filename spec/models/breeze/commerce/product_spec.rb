require 'spec_helper'

describe Breeze::Commerce::Product do

	# subject do 
	# 	create(:order, store: Breeze::Commerce::Store.first)
	# end


	it "has a valid factory" do
		create(:product).should be_valid
	end

	it "reports whether it has a tag with a given name"

end
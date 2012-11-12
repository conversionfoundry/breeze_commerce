require 'spec_helper'


describe Breeze::Commerce::OrdersController do

	describe "PUT #submit_order" do
    context "visitor (not logged in)" do
    	it "foo" do
    		binding.pry
    		# controller.stub :params, {foo: :bar}
		  	# put controller.submit_order #, foo: :bar, order: create(:order)
		  	put :submit_order, order: attributes_for(:order)
		  	response.should be_success
	    end
		end
	end

end
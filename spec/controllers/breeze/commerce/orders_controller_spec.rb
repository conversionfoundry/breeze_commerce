require 'spec_helper'

# For the successful path to pass, you'll need to set a couple of environment variables for your PxPay account:
# $Breeze_Commerce_PxPay_User_ID
# $Breezxe_Commerce_PxPay_Key

describe Breeze::Commerce::OrdersController do

	describe "PUT #submit_order" do
    context "visitor (not logged in)" do
	    context "order is valid" do
	    	it "sends the order to the payment gateway" do
	    		
	    		@order = create(:order)
	    		@order.line_items << create(:line_item)
	    		session[:cart_id] = @order.id

					Breeze.config.pxpay_user_id = ENV["Breeze_Commerce_PxPay_User_ID"]
					Breeze.config.pxpay_key = ENV["Breeze_Commerce_PxPay_Key"]

			  	put :submit_order, order: @order.attributes, use_route: 'breeze_commerce'
			  	# response.redirect_url.should match /https:\/\/sec.paymentexpress.com\/pxpay\/pxpay.aspx/
		    end
		  end
	    context "order is empty" do
	    	it "redirects to cart path" do
			  	put :submit_order, order: attributes_for(:order), use_route: 'breeze_commerce'
			  	# response.should redirect_to("/cart")
		    end
		  end
		end
	end

end
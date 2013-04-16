require 'spec_helper'
include RSpec::Matchers

# For the successful path to pass, you'll need to set a couple of environment variables for your PxPay account:
# $PXPAY_USER_ID
# $PXPAY_KEY

describe Breeze::Commerce::OrdersController do

  describe "Environment variables set up" do
    ENV["PXPAY_USER_ID"].should_not be_nil
    ENV["PXPAY_KEY"].should_not be_nil
  end

  describe "PUT #submit" do
    context "visitor (not logged in)" do
      context "order is valid" do
        it "sends the order to the payment gateway" do

          @order = create(:order)
          @order.line_items << create(:line_item)
          session[:cart_id] = @order.id

          Breeze.config.pxpay_user_id = ENV["PXPAY_USER_ID"]
          Breeze.config.pxpay_key = ENV["PXPAY_KEY"]

          put :submit, id: @order.id, use_route: 'breeze_commerce'
          response.redirect_url.should match /https:\/\/sec.paymentexpress.com\/pxpay\/pxpay.aspx/
        end
      end
      context "order is empty" do
        it "redirects to cart path" do
          @order = create(:empty_order)
          put :submit, id: @order.id, use_route: 'breeze_commerce'
          response.should redirect_to("/orders/#{@order.id}/edit")
        end
      end
    end
  end

  describe "Order security" do
    context "registered customer" do
      it "can show own orders"
      it "can't show other customer's orders"
      it "can't show guest orders"
      it "can't confirm same order twice"
    end
    context "guest customer" do
      it "can show order after confirmation"
      it "can't show customer orders"
      it "can't show guest orders"
      it "can't confirm same order twice"
    end
  end

end
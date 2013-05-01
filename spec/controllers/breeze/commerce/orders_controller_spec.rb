require 'spec_helper'
include RSpec::Matchers

# For the successful path to pass, you'll need to set a couple of environment variables for your PxPay account:
# $PXPAY_USER_ID
# $PXPAY_KEY

describe Breeze::Commerce::OrdersController do

  before :each do
    Breeze.config.pxpay_user_id = ENV["PXPAY_USER_ID"]
    Breeze.config.pxpay_key = ENV["PXPAY_KEY"]
  end

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

  describe "GET #edit" do
    before :each do
      create(:country)
    end

    context "registered customer" do
      it "can edit own orders" do
        sign_in FactoryGirl.create(:customer)

        @order = create(:order)
        @order.line_items << create(:line_item)

        get :edit, id: @order.id, use_route: 'breeze_commerce'
        response.should be_success
      end
      it "can't edit another customer's orders" do
        sign_in FactoryGirl.create(:customer)

        @order = create(:order)
        @order.line_items << create(:line_item)

        sign_in FactoryGirl.create(:different_customer)

        get :edit, id: @order.id, use_route: 'breeze_commerce'
        response.should_not be_success
      end
      it "can't edit guest orders" do
        @order = create(:order)
        @order.line_items << create(:line_item)

        sign_in FactoryGirl.create(:customer)

        get :edit, id: @order.id, use_route: 'breeze_commerce'
        response.should_not be_success
      end

    end
    context "guest customer" do
      it "can edit order after confirmation"
      it "can't edit customer orders"
      it "can't edit guest orders"
    end
  end

  describe "confirm order" do

    before :each do
      create(:country)
    end

    context "registered customer" do
      it "can't confirm same order twice"
    end
    context "guest customer" do
      it "can't confirm same order twice"
    end
  end

end
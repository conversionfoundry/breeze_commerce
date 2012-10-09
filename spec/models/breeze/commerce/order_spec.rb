require 'spec_helper'

describe Breeze::Commerce::Order do

	subject do 
		create(:order, store: Breeze::Commerce::Store.first)
	end


	it "has a valid factory" do
		# create(:order)
		create(:order).should be_valid
	end
	it "has the default associations when first created" do
		order = create(:order, store: Breeze::Commerce::Store.first)
		order.billing_status.name.should eq 'Browsing'
		order.shipping_status.name.should eq 'Not Shipped Yet'
	end
	it "has a store" do
		create(:order).store.should eq Breeze::Commerce::Store.first
	end
	it "is invalid without a store" do
		order = create :order
		order.store = nil
		order.should_not be_valid
	end
	it "doesn't return a nil billing status" do
		order = create :order
		order.billing_status = nil
		order.should be_valid
		order.billing_status.name.should eq 'Browsing'
	end
	it "doesn't return a nil shipping status" do
		order = create :order
		order.shipping_status = nil
		order.should be_valid
		order.shipping_status.name.should eq 'Not Shipped Yet'
	end
	it "is valid with a duplicate email address" do
		create(:order, email: "foo@example.com")
		build(:order, email: "foo@example.com").should be_valid
	end

	it "has a name"
	it "has an item total"
	it "shows in admin if order status isn't Browsing"
	it "doesn't show in admin if order status is Browsing"
	it "can have a billing address"
	it "can have a shipping address"

	describe "scopes" do
		before :each do
			@order1 = create(:order)
			@order2 = create(:order)
			@order3 = create(:order, archived: true)
			@order4 = create(:order, archived: true)
		end			
		context "unarchived scope" do
			it "returns an array of unarchived orders" do
				Breeze::Commerce::Order.unarchived.to_a.should eq [@order1, @order2]
				Breeze::Commerce::Order.unarchived.should_not include @order3
				Breeze::Commerce::Order.unarchived.should_not include @order4
			end
		end
		context "archived scope" do
			it "returns an array of archived orders" do
				Breeze::Commerce::Order.archived.to_a.should eq [@order3, @order4]
				Breeze::Commerce::Order.archived.should_not include @order1
				Breeze::Commerce::Order.archived.should_not include @order2
			end
		end
	end

end
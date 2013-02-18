require 'spec_helper'

describe Breeze::Commerce::Order do

	subject { create(:order) }

	describe "validation" do
		it { should be_valid }
		it "is valid with a duplicate email address" do
			create(:order, email: "foo@example.com")
			build(:order, email: "foo@example.com").should be_valid
		end
		it "is invalid without a shipping method"
		it "gives an appropriate warning message if there are no shipping methods"
		it "gives an appropriate warning message if there are no countries"
	end

	context "when first created" do
		before :each do 
			@order = create(:order)
		end
		describe "order statuses" do
			it "has the default billing status" do
				@order.billing_status.name.should eq 'Browsing'
			end
			it "has the default shipping status" do
				@order.shipping_status.name.should eq 'Not Shipped Yet'
			end
		end

		it "has the default shipping method for the default country"

	end

	describe "line item methods" do	
		context "when there are no line items or shipping methods" do
			before :each do 
				@order = create(:order)
			end
			it "has zero line item count" do
				@order.item_count.should eq 0
			end
			it "has zero line item total" do
				@order.item_total.should eq 0
			end
			it "has zero line item total in cents" do
				@order.item_total_cents.should eq 0
			end
			it "has zero shipping total" do
				@order.shipping_total.should eq 0
			end
			it "reports zero total including shipping" do
				@order.total.should eq 0
			end
		end
		context "when there are line items and a shipping method" do
			before :each do 
				@order = create(:order)
				@variant1 = create(:variant, sell_price_cents: 2000)
				@variant2 = create(:variant, sell_price_cents: 1234)
				@order.line_items << create(:line_item, quantity: 2, variant: @variant1)
				@order.line_items << create(:line_item, quantity: 1, variant: @variant2)
				@order.shipping_method = create(:shipping_method, price: 10)
			end
			it "has correct line item count" do
				@order.item_count.should eq 3
			end
			it "has correct line item total" do
				@order.item_total.should eq 52.34
			end
			it "has correct line item total in cents" do
				@order.item_total_cents.should eq 5234
			end
			it "has correct shipping total" do
				@order.shipping_total.should eq 10
			end
			it "reports correct total including shipping" do
				@order.total.should eq 62.34
			end
		end
	end

	describe "show_in_admin scope" do
		before :each do
			@order = create(:order)
		end
		context "billing status is 'Browsing'" do
			it "doesn't appear in admin" do
				@order.billing_status = Breeze::Commerce::OrderStatus.billing.where(name: 'Browsing').first
				@order.save
				Breeze::Commerce::Order.show_in_admin.should_not include @order
			end
		end
		context "billing status is 'Started Checkout'" do
			it "doesn't appear in admin" do
				@order.billing_status = Breeze::Commerce::OrderStatus.billing.where(name: 'Started Checkout').first
				@order.save
				Breeze::Commerce::Order.show_in_admin.should_not include @order
			end		
		end
		context "billing_status is neither" do
			it "doesn't appear in admin" do
				@order.billing_status = Breeze::Commerce::OrderStatus.billing.where(name: 'Payment Received').first
				@order.save
				Breeze::Commerce::Order.show_in_admin.should include @order
			end		
		end
	end
	
	describe "order number" do
		context "when unsaved" do
			it "has an Xed order number" do
				@order = build(:order)
				@order.order_number.should eq 'XXXX-XX-XX-XXXXX'
			end
		end
		context "when saved" do
			it "has an order number" do
				@order = create(:order)
				@order.order_number.should match /\d{4}-\d{2}-\d{2}-\d{5}/
			end
		end
	end

	describe "name method" do
		before :each do
			@order = create(:order)
		end	
		context "when it has a billing address" do
			it "returns the billing address name" do
				@order = create(:order, billing_address: build(:address, name: 'foo') )
				@order.name.should eq 'foo'
			end
		end
		context "when there's no billing address" do
			it "returns 'unknown'" do
				@order.name.should eq 'unknown'
			end
		end
	end

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
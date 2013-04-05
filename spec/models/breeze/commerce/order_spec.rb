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

  describe "actionable scope" do
    before :each do
      @order = create(:order)
    end
    context "billing status is 'Browsing'" do
      it "doesn't appear in admin" do
        @order.billing_status = Breeze::Commerce::OrderStatus.billing.where(name: 'Browsing').first
        @order.save
        Breeze::Commerce::Order.actionable.should_not include @order
      end
    end
    context "billing status is 'Started Checkout'" do
      it "doesn't appear in admin" do
        @order.billing_status = Breeze::Commerce::OrderStatus.billing.where(name: 'Started Checkout').first
        @order.save
        Breeze::Commerce::Order.actionable.should_not include @order
      end   
    end
    context "billing_status is neither" do
      it "doesn't appear in admin" do
        @order.billing_status = Breeze::Commerce::OrderStatus.billing.where(name: 'Payment Received').first
        @order.save
        Breeze::Commerce::Order.actionable.should include @order
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

  describe "coupon_total" do
    context "no serialized_coupon" do
      it "is zero" do
        subject.coupon_total.should eq 0
      end
    end
    context "serialized_coupon is present" do
      before :each do
        coupon = create(:coupon)
        subject.serialize_coupon coupon
      end
      it "returns the total calculated by the coupon" do
        subject.coupon_total.should eq coupon.calculate_discount(subject)
      end
      it "returns the total in dollars (not cents)" do
        subject.coupon_total.should eq 1
      end
    end
  end

  describe "total" do
    it "is line item total plus shipping total, minus coupon total" do
      subject.stub(:item_total){100}
      subject.stub(:coupon_total){20}
      subject.stub(:shipping_total){10}
      subject.total.should eq 90
    end
    it "doesn't allow coupons to discount more than the line item total" do
      subject.stub(:item_total){100}
      subject.stub(:coupon_total){120}
      subject.stub(:shipping_total){10}
      subject.total.should eq 10
    end
  end

	describe "can_resend?" do
		before :each do
			@customer = create(:customer)
			@order = create(:order, customer: @customer)
			@variant1 = create(:variant, sell_price_cents: 2000)
			@variant2 = create(:variant, sell_price_cents: 1234)
			@order.line_items << create(:line_item, quantity: 2, variant: @variant1)
			@order.line_items << create(:line_item, quantity: 1, variant: @variant2)
		end
		it "is false if there's no customer" do
			@order.customer = nil
			@order.can_resend?.should eq false
		end
		it "is true if all line_items are for variants that are still available" do
			@order.can_resend?.should eq true
		end
		it "is false if a line_item's variant is archived" do
			@variant1.update_attribute(:archived, true)
			@order.can_resend?.should eq false
		end
		it "is false if a line_item's variant doesn't exist" do
			@variant1.destroy
			@order.can_resend?.should eq false
		end
	end

	describe "duplicate_for_resend" do
		context "original order has can_resend? == true" do
			before :each do
				@customer = create(:customer)
				@original_order = create(:order, customer: @customer)
				@variant1 = create(:variant, sell_price_cents: 2000)
				@variant2 = create(:variant, sell_price_cents: 1234)
				@original_order.line_items << create(:line_item, quantity: 2, variant: @variant1)
				@original_order.line_items << create(:line_item, quantity: 1, variant: @variant2)		
				@new_order = @original_order.duplicate_for_resend	
			end
			it "has line items with matching fields" do
				original_line_item = @original_order.line_items.first
				new_line_item = @new_order.line_items.first
				new_line_item.variant.should eq original_line_item.variant
				new_line_item.quantity.should eq original_line_item.quantity
			end
			it "has line items with new ids" do
				@new_order.line_items.first.should_not eq @original_order.line_items.first
			end
			it "has the same customer" do
				@new_order.customer.should eq @original_order.customer
			end
			it "has billing_status reset" do
				@new_order.billing_status.should eq Breeze::Commerce::OrderStatus.billing_default
			end
			it "has shipping_status reset" do
				@new_order.shipping_status.should eq Breeze::Commerce::OrderStatus.shipping_default
			end
		end
		it "fails if can_resend? is false" do
			@customer = create(:customer)
			@original_order = create(:order, customer: @customer)
			@original_order.stub(:can_resend?){false} 
			@original_order.duplicate_for_resend.should eq false
		end
	end

end
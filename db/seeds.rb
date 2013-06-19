store = Breeze::Commerce::Store.create

store.initial_billing_status = Breeze::Commerce::OrderStatus.create(:type => :billing, :name => "Browsing", :sort_order => 0,:description => "Customer has added items to his or her cart, but hasn't gone to checkout yet")
store.checkout_billing_status = Breeze::Commerce::OrderStatus.create(:type => :billing, :name => "Started Checkout", :sort_order => 1, :description => "Customer has taken this order to checkout")
store.with_gateway_billing_status = Breeze::Commerce::OrderStatus.create(:type => :billing, :name => "Payment in process", :sort_order => 2, :description => "Customer has clicked Pay Now, and the order is currently with the payment processor")
store.payment_confirmed_billing_status = Breeze::Commerce::OrderStatus.create(:type => :billing, :name => "Payment Confirmed", :sort_order => 3, :description => "Payment has been approved by payment gateway")
store.initial_shipping_status = Breeze::Commerce::OrderStatus.create(:type => :shipping, :name => "Not Shipped Yet", :sort_order => 0, :description => "Newly-created order")
store.shipped_shipping_status = Breeze::Commerce::OrderStatus.create(:type => :shipping, :name => "Processing", :sort_order => 1, :description => "Getting ready to ship")
store.save

Breeze::Commerce::OrderStatus.create(:type => :billing, :name => "Payment Received", :sort_order => 4, :description => "Full payment has been received")
Breeze::Commerce::OrderStatus.create(:type => :billing, :name => "Cancelled by Customer", :sort_order => 5, :description => "Customer cancelled order")
Breeze::Commerce::OrderStatus.create(:type => :billing, :name => "Cancelled by Merchant", :sort_order => 6, :description => "Merchant cancelled order")
Breeze::Commerce::OrderStatus.create(:type => :billing, :name => "Disputed", :sort_order => 7, :description => "Something's gone wrong")

Breeze::Commerce::OrderStatus.create(:type => :shipping, :name => "Shipped", :sort_order => 2, :description => "Order has been shipped")
Breeze::Commerce::OrderStatus.create(:type => :shipping, :name => "Will Not Ship", :sort_order => 3, :description => "Shipping has been cancelled")

Breeze::Commerce::Shipping::ShippingMethod.create(:price => 10, :name => "Standard Shipping")

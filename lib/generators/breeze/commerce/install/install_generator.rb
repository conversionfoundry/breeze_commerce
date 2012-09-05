# class InstallGenerator < Rails::Generators::NamedBase
#   source_root File.expand_path('../templates', __FILE__)
# end

require 'rails/generators'

module Breeze
	module Commerce
	  module Generators
	    class InstallGenerator < Rails::Generators::Base
	    	source_root File.expand_path('../templates', __FILE__)

	      def install_breeze_commerce
	      	store = Breeze::Commerce::Store.first || Breeze::Commerce::Store.create

	      	# Generate built-in order statuses for billing
	        if Breeze::Commerce::OrderStatus.where(:type => :billing, :name => "New").count == 0
	        	Breeze::Commerce::OrderStatus.create(:type => :billing, :name => "New", :description => "Newly-created order", :store => store)
	        end
	        if Breeze::Commerce::OrderStatus.where(:type => :billing, :name => "Payment in process").count == 0
	        	Breeze::Commerce::OrderStatus.create(:type => :billing, :name => "Payment in process", :description => "Order is currently with the payment processor", :store => store)
	        end
	        if Breeze::Commerce::OrderStatus.where(:type => :billing, :name => "Payment Received").count == 0
	        	Breeze::Commerce::OrderStatus.create(:type => :billing, :name => "Payment Received", :description => "Order has been paid in full", :store => store)
	        end
	        if Breeze::Commerce::OrderStatus.where(:type => :billing, :name => "Partial Payment Received").count == 0
	        	Breeze::Commerce::OrderStatus.create(:type => :billing, :name => "Partial Payment Received", :description => "Some payment has been received, but not full", :store => store)
	        end
	        if Breeze::Commerce::OrderStatus.where(:type => :billing, :name => "Payment Declined").count == 0
	        	Breeze::Commerce::OrderStatus.create(:type => :billing, :name => "Payment Declined", :description => "Payment processor reports that payment failed", :store => store)
	        end
	        if Breeze::Commerce::OrderStatus.where(:type => :billing, :name => "Cancelled by Customer").count == 0
	        	Breeze::Commerce::OrderStatus.create(:type => :billing, :name => "Cancelled by Customer", :description => "Customer cancelled order", :store => store)
	        end
	        if Breeze::Commerce::OrderStatus.where(:type => :billing, :name => "Cancelled by Merchant").count == 0
	        	Breeze::Commerce::OrderStatus.create(:type => :billing, :name => "Cancelled by Merchant", :description => "Merchant cancelled order", :store => store)
	        end
	        if Breeze::Commerce::OrderStatus.where(:type => :billing, :name => "Disputed").count == 0
	        	Breeze::Commerce::OrderStatus.create(:type => :billing, :name => "Disputed", :description => "Something's gone wrong", :store => store)
	        end

	      	# Generate built-in order statuses for billing
	        if Breeze::Commerce::OrderStatus.where(:type => :shipping, :name => "New").count == 0
	        	Breeze::Commerce::OrderStatus.create(:type => :shipping, :name => "New", :description => "Newly-created order", :store => store)
	        end
	        if Breeze::Commerce::OrderStatus.where(:type => :shipping, :name => "Processing").count == 0
	        	Breeze::Commerce::OrderStatus.create(:type => :shipping, :name => "Processing", :description => "Getting ready to ship", :store => store)
	        end
	        if Breeze::Commerce::OrderStatus.where(:type => :shipping, :name => "Delivered").count == 0
	        	Breeze::Commerce::OrderStatus.create(:type => :shipping, :name => "Delivered", :description => "Order has been shipped", :store => store)
	        end
	        if Breeze::Commerce::OrderStatus.where(:type => :shipping, :name => "Will Not Deliver").count == 0
	        	Breeze::Commerce::OrderStatus.create(:type => :shipping, :name => "Will Not Deliver", :description => "Shipping has been cancelled", :store => store)
	        end
	      end
	    end
	  end
	end
end

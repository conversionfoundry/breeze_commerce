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

	        if Breeze::Commerce::OrderStatus.where(:name => "New").count == 0
	        	Breeze::Commerce::OrderStatus.create(:name => "New", :description => "Default status for newly-created orders", :store => store)
	        end

	        if Breeze::Commerce::OrderStatus.where(:name => "Payment in process").count == 0
	        	Breeze::Commerce::OrderStatus.create(:name => "Payment in process", :description => "Order is currently with the payment processor", :store => store)
	        end

	        if Breeze::Commerce::OrderStatus.where(:name => "Payment Received").count == 0
	        	Breeze::Commerce::OrderStatus.create(:name => "Payment Received", :description => "Order has been paid in full", :store => store)
	        end

	        if Breeze::Commerce::OrderStatus.where(:name => "Partial Payment Received").count == 0
	        	Breeze::Commerce::OrderStatus.create(:name => "Partial Payment Received", :description => "Some payment has been received, but not full", :store => store)
	        end

	        if Breeze::Commerce::OrderStatus.where(:name => "Payment Declined").count == 0
	        	Breeze::Commerce::OrderStatus.create(:name => "Payment Declined", :description => "Payment processor reports that payment failed", :store => store)
	        end

	        if Breeze::Commerce::OrderStatus.where(:name => "Cancelled by Customer").count == 0
	        	Breeze::Commerce::OrderStatus.create(:name => "Cancelled by Customer", :description => "Customer cancelled order", :store => store)
	        end

	        if Breeze::Commerce::OrderStatus.where(:name => "Cancelled by Merchant").count == 0
	        	Breeze::Commerce::OrderStatus.create(:name => "Cancelled by Merchant", :description => "Merchant cancelled order", :store => store)
	        end

	        if Breeze::Commerce::OrderStatus.where(:name => "Disputed").count == 0
	        	Breeze::Commerce::OrderStatus.create(:name => "Disputed", :description => "Something's gone wrong", :store => store)
	        end

	      end
	    end
	  end
	end
end

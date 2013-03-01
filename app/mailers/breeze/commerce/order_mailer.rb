# encoding: UTF-8
module Breeze
	module Commerce
	  class OrderMailer < Breeze::Mailer

      helper Breeze::ContentsHelper
      helper Breeze::Commerce::ContentsHelper
      helper Breeze::Commerce::AddressesHelper

	    def new_order_merchant_notification(order)
	      merchants = Breeze::Admin::User.all.select{|user| user.roles.include? :merchant}
	      @site = Socket.gethostname
	      @order = order
	      @subject = "New Order #{@order.order_number} at #{@site}"
	      merchants.each do |merchant|
	      	@merchant = merchant
		      message = mail(
		      	:to => merchant.email, 
		      	:from => Breeze.config.notification_from_email, 
		      	:subject => @subject
		      ) 
			    message.body = render( template_path('breeze/commerce/order_mailer/new_order_merchant_notification') )
		    end
	    end

	    def new_order_customer_notification(order)
	      @site = Socket.gethostname
	      @order = order
	      @subject = "Received Order #{@order.order_number} at #{@site}"
	      mail(
	      	:to => @order.email, 
	      	:from => Breeze.config.notification_from_email, 
	      	:subject => @subject
	      )
		    message.body = render( template_path('breeze/commerce/order_mailer/new_order_customer_notification') )
	    end

	    def shipping_status_change_customer_notification(order)
	      @site = Socket.gethostname
	      @order = order
	      @subject = "Shipping Status Update for Order #{@order.order_number} at #{@site}"
	      mail(
	      	:to => @order.email, 
	      	:from => Breeze.config.notification_from_email, 
	      	:subject => @subject
	      )
		    message.body = render( template_path('breeze/commerce/order_mailer/shipping_status_change_customer_notification') )
	    end

	  end
	end
end

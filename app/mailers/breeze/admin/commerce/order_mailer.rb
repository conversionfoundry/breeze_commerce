# encoding: UTF-8
module Breeze
	module Admin
		module Commerce
		  class OrderMailer < Breeze::Mailer

	      helper Breeze::ContentsHelper
	      helper Breeze::Commerce::ContentsHelper

		    def new_order_admin_notification(order)
		    	# TODO: Use a merchant role, not admin
		      admins = Breeze::Admin::User.all.select{|user| user.roles.include? :admin}
		      @site = Socket.gethostname
		      @order = order
		      @subject = "New Order #{@order.order_number} at #{@site}"
		      admins.each do |admin|
		      	@admin = admin
			      mail(
			      	:to => admin.email, 
			      	:from => Breeze.config.notification_from_email, 
			      	:subject => @subject
			      )
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
		    end

		  end
		end
	end
end

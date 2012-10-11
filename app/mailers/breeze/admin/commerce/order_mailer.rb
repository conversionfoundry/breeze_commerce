# encoding: UTF-8
module Breeze
	module Admin
		module Commerce
		  class OrderMailer < Breeze::Mailer

		    def new_order_admin_notification(order)
		    	# TODO: Use a merchant role, not admin
		      admins = Breeze::Admin::User.all.select{|user| user.roles.include? :admin}
		      @site = Socket.gethostname
		      @order = order
		      admins.each do |admin|
		      	@admin = admin
			      mail(
			      	:to => admin.email, 
			      	:from => Breeze.config.notification_from_email, 
			      	:subject => "Order #{@order.order_number} at #{@site}"
			      )
			    end
		    end

		    def new_order_customer_notification(order)
		      @site = Socket.gethostname
		      @order = order
		      mail(
		      	:to => @order.email, 
		      	:from => Breeze.config.notification_from_email, 
		      	:subject => "Order #{@order.order_number} at #{@site}"
		      )
		    end

		  end
		end
	end
end

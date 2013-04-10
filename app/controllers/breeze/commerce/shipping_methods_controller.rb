module Breeze
  module Commerce
    class ShippingMethodsController < Breeze::Commerce::Controller
      def index
      	# if params[:country_id]
      	# 	country = Breeze::Commerce::Shipping::Country.find(params[:country_id])
      	# 	@shipping_methods = country.shipping_methods
      	# else
      	# 	@shipping_methods = Breeze::Commerce::Shipping::ShippingMethods.all
      	# end
      	# @order = Breeze::Commerce::Order.find params[:order_id]
       #  @countries = Breeze::Commerce::Shipping::Country.order_by(:name.asc)
      end
    end
  end
end

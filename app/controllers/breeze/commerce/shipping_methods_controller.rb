module Breeze
  module Commerce
    class ShippingMethodsController < Breeze::Commerce::Controller
      def index
      	if params[:country_id]
      		country = Breeze::Commerce::Country.find(params[:country_id])
      		@shipping_methods = country.shipping_methods
      	else
      		@shipping_methods = Breeze::Commerce::ShippingMethods.all
      	end
      	@order = Breeze::Commerce::Order.find params[:order_id]
      end
    end
  end
end

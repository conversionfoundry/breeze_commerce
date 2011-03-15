module Breeze
  module Commerce
    class OrdersController < ApplicationController

      # Displays the current cart
      def edit
        @order = current_order
      end

      def remove_item
        @order = current_order
        line_item = @order.line_items.find(params[:id])
        line_item.delete if line_item
      end

      def populate
        @order = current_order
        
        @order.line_items << LineItem.new(:product_id => params[:product_id], :quantity => params[:quantity])
        @order.save

        redirect_to cart_path
      end

      def checkout
        @order = current_order 
      end

      protected
      def current_order  # TODO: move this to a helper
        return @current_order if @current_order
        if (session[:cart_id])
          @current_order = Order.find(session[:cart_id])
          # TODO: check if it has been purchased or not
        else
          @current_order = Order.create!
          session[:cart_id] = @current_order.id
        end
        @current_order
      end      
    end
  end
end


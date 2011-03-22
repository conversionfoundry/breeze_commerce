module Breeze
  module Commerce
    class OrdersController < ApplicationController
      include Breeze::Commerce::CurrentOrder

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

      def submit
        @order = current_order

        if @order.save
          redirect_to :action => "thankyou"
        else
          render :action => "checkout"
        end
      end 

      def thankyou 
        @order = current_order
      end

    end
  end
end


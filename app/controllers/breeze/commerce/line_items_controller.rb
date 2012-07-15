module Breeze
  module Commerce
    class LineItemsController < Breeze::Commerce::Controller #ApplicationController 
      def update
        @order = Order.find(params[:order_id])
        @line_item = @order.line_items.find(params[:id])
        @line_item.update_attributes(params[:breeze_commerce_line_item])
        redirect_to breeze.cart_path
        
      end

      def destroy
        @order = Order.find(params[:order_id])
        #TODO: check that order is in "checkout" state
        @line_item = @order.line_items.find(params[:id])
        @line_item.delete
        redirect_to breeze.cart_path
        
      end
    end
  end
end
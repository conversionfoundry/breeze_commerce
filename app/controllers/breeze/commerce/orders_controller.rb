module Breeze
  module Commerce
    class OrdersController < Controller  #ApplicationController
      layout "breeze/commerce/order"
      include Breeze::Commerce::CurrentOrder

      def print
        @order = Order.find params[:id]
      end

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
        
        product_id = params[:product_id]
        new_line_item =  Breeze::Commerce::LineItem.new(:product_id => product_id, :quantity => params[:quantity] || 1)
        existing_line_item = @order.line_items.where(:product_id => product_id).first 
        if existing_line_item
          existing_line_item.quantity += new_line_item.quantity
        else
          @order.line_items << new_line_item
        end

        @order.save
        
        redirect_to cart_path
      end

      def checkout
        @order = current_order 
      end

      def update
        @order = current_order
        if params[:order].has_key? :shipping_method
          params[:order].delete(:shipping_method)
        end
        @order.update_attributes params[:order]

        if @order.save
          redirect_to :action => "thankyou"
        else
          render :action => "checkout"
        end
      end 

      def thankyou 
        @order = current_order
        # @order = current_order
      end

    end
  end
end


module Breeze
  module Commerce
    class OrdersController < Breeze::Commerce::Controller  #ApplicationController
      helper Breeze::ContentsHelper

      layout "breeze/commerce/order"
      include Breeze::Commerce::ContentsHelper

      def print
        @order = Order.find params[:id]
      end

      # This is currently here to make the checkout form work
      def show
      end

      # Displays the current cart
      def edit
        @order = current_order(session)
      end

      def remove_item
        @order = current_order(session)
        line_item = @order.line_items.find(params[:id])
        line_item.delete if line_item
      end

      def populate
        @order = current_order(session)
        
        # product_id = params[:product_id]
        variant_id = params[:variant_id]
        
        # new_line_item =  Breeze::Commerce::LineItem.new(:product_id => product_id, :quantity => params[:quantity] || 1)
        new_line_item =  Breeze::Commerce::LineItem.new(:variant_id => variant_id, :quantity => params[:quantity] || 1)
        # existing_line_item = @order.line_items.where(:product_id => product_id).first 
        existing_line_item = @order.line_items.where(:variant_id => variant_id).first 
        if existing_line_item
          existing_line_item.quantity += new_line_item.quantity
        else
          @order.line_items << new_line_item
        end

        @order.save
        
        redirect_to breeze.cart_path
      end

      def checkout
        @order = current_order(session)
      end

      def create
      end

      def update
        @order = current_order(session)
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
        @order = current_order(session)
      end

    end
  end
end
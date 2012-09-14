module Breeze
  module Admin
    module Commerce
      class LineItemsController < ApplicationController 
        def update
          @order = Order.find(params[:order_id])
          @line_item = @order.line_items.find(params[:id])
          @line_item.update_attributes(params[:breeze_commerce_line_item])
        end

        def destroy
          @order = Order.find(params[:order_id])
          #TODO: check that order is in "checkout" state
          @line_item = @order.line_items.find(params[:id])
          @line_item.update_attributes(:archived => true)
        end
      end
    end
  end
end

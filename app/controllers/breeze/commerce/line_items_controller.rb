module Breeze
  module Commerce
    class LineItemsController < Breeze::Commerce::Controller #ApplicationController 


      def update
        @order = Order.find(params[:order_id])
        @line_item = @order.line_items.find(params[:id])
        @line_item.update_attributes(params[:line_item])
        respond_to do |format|
          format.js { render :template => '/breeze/commerce/line_items/update', :status => :ok }
        end
      end

      def destroy
        @order = Order.find(params[:order_id])
        #TODO: check that order is in "checkout" state
        @line_item = @order.line_items.find(params[:id])
        @line_item.delete

        if @order.line_items.count == 0
          @redirect_url = store.home_page.permalink
          render :redirect
        end

      end


    end
  end
end
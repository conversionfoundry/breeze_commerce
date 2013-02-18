module Breeze
  module Commerce
    class LineItemsController < Breeze::Commerce::Controller
      include Breeze::Commerce::CurrentOrder

      def create
        @order = current_order(session)
        @line_item = @order.line_items.unarchived.where(:variant_id => params[:line_item][:variant_id], customer_message: params[:line_item][:customer_message]).first 
        if @line_item # && @line_item.variant.requires_customer_message == false
          @line_item.quantity += params[:line_item][:quantity].to_i
        else
          @line_item =  Breeze::Commerce::LineItem.new params[:line_item].merge({order_id: @order.id})
        end
        @line_item.save
      end

      def update
        @order = Order.find(params[:order_id])
        @line_item = @order.line_items.find(params[:id])
        @line_item.update_attributes(params[:line_item])
        @update_order_total = params[:update_order_total]
        respond_to do |format|
          format.js { render :template => '/breeze/commerce/line_items/update', :status => :ok }
        end
      end

      def destroy
        @order = Order.find(params[:order_id])
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
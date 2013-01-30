module Breeze
  module Admin
    module Commerce
      class LineItemsController < Breeze::Admin::Commerce::Controller 

        def new
          @order = Breeze::Commerce::Order.find(params[:order_id]) 
          @line_item = @order.line_items.new         
          @products = Breeze::Commerce::Product.includes(:variants).unarchived.order_by(:created_at.desc)
        end

        def create
          @order = Breeze::Commerce::Order.find(params[:order_id])
          @line_item = @order.line_items.create(params[:line_item])
          @products = Breeze::Commerce::Product.includes(:variants).unarchived.order_by(:created_at.desc)
          @order.shipping_address ||= Breeze::Commerce::Address.new
          @order.billing_address ||= Breeze::Commerce::Address.new
          @billing_statuses = Breeze::Commerce::OrderStatus.billing
          @shipping_statuses = Breeze::Commerce::OrderStatus.shipping
        end

        def update
          @order = Breeze::Commerce::Order.find(params[:order_id])
          @line_item = @order.line_items.find(params[:id])
          @line_item.update_attributes(params[:breeze_commerce_line_item])
        end

        def destroy
          @order = Breeze::Commerce::Order.find(params[:order_id])
          @line_item = @order.line_items.find(params[:id])
          @line_item.update_attributes(:archived => true)
          @products = Breeze::Commerce::Product.includes(:variants).unarchived.order_by(:created_at.desc)
          @order.shipping_address ||= Breeze::Commerce::Address.new
          @order.billing_address ||= Breeze::Commerce::Address.new
          @billing_statuses = Breeze::Commerce::OrderStatus.billing
          @shipping_statuses = Breeze::Commerce::OrderStatus.shipping
        end
      end
    end
  end
end

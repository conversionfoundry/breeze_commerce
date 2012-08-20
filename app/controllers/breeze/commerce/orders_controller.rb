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
        @customer = current_customer || Breeze::Commerce::Customer.new
        @order = current_order(session)
      end

      # Checkout completed, ready to process order
      # TODO: Currently this code skips the actual payment.
      # TODO: Not sure whether to call this action "update" or not. Is "u"
      def submit_order
        @order = current_order(session)
        
        @order = store.orders.build params[:order]
        
        if customer_signed_in?
          @order.customer = current_customer
        elsif params[:order][:create_new_account]
          # create and save a new customer
          new_customer = Breeze::Commerce::Customer.new(
            :first_name => params[:order][:billing_address][:first_name],
            :last_name => params[:order][:billing_address][:last_name],
            :email => params[:order][:email],
            :password => 'TODO:properpassword',
            :password_confirmation => 'TODO:properpassword',
            :store => store
          )
          if new_customer.save
            # set the order's customer
            @order.customer = new_customer
          end
        end
        
        

       
        binding.pry

        if @order.save


          redirect_to breeze.thankyou_path
        else
          render :action => "checkout"
        end
      end

      def create
      end

      # Old Code
      def update
        @order = current_order(session)
        if params[:order].has_key? :shipping_method
          params[:order].delete(:shipping_method)
        end
        @order.update_attributes params[:order]

        if @order.save
          redirect_to breeze.thankyou_path
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
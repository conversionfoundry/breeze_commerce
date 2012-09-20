module Breeze
  module Commerce
    class OrdersController < Breeze::Commerce::Controller
      helper Breeze::ContentsHelper
      layout "breeze/commerce/checkout_funnel"
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
        shipping_methods = store.shipping_methods.unarchived
        unless @order.shipping_method && shipping_methods.include?(@order.shipping_method)
          if store.shipping_methods.count > 1
            @order.shipping_method = shipping_methods.unarchived.where(:is_default => true).first
          else
            @order.shipping_method = shipping_methods.unarchived.first
          end
          @order.save
        end
      end

      def remove_item
        @order = current_order(session)
        line_item = @order.line_items.find(params[:id])
        line_item.delete if line_item
      end

      # Add items to the order (i.e. the shopping cart)
      def populate
        @order = current_order(session) || create_order(session)
        
        # product_id = params[:product_id]
        variant_id = params[:variant_id]
                
        new_line_item =  Breeze::Commerce::LineItem.new(:variant_id => variant_id, :quantity => params[:quantity] || 1)
        existing_line_item = @order.line_items.unarchived.where(:variant_id => variant_id).first 
        if existing_line_item
          existing_line_item.quantity += new_line_item.quantity
        else
          @order.line_items << new_line_item
        end

        @order.save
      end

      def checkout
        @order = current_order(session)
        @order.billing_status = Breeze::Commerce::OrderStatus.where(:type => :billing, :name => "Started Checkout").first
        @order.save
        @customer = current_customer || Breeze::Commerce::Customer.new
        @customer.shipping_address ||= Breeze::Commerce::Address.new
        @customer.billing_address ||= Breeze::Commerce::Address.new
      end

      # Checkout completed, ready to process order
      # TODO: Currently this code skips the actual payment.
      # TODO: Not sure whether to call this action "update" or not. Is "u"
      def submit_order
        @order = current_order(session)
        
        # @order = store.orders.build params[:order]
        @order.update_attributes params[:order]
        

        if customer_signed_in?
          @order.customer = current_customer
        elsif params[:create_new_account]
          # create and save a new customer
          new_customer = Breeze::Commerce::Customer.new(
            :first_name => params[:order][:billing_address][:name].split(' ').first,
            :last_name => params[:order][:billing_address][:name].split(' ').last,
            :email => params[:order][:email],
            :password => params[:new_account_password],
            :password_confirmation => params[:new_account_password],
            :store => store
          )
          new_customer.shipping_address = Breeze::Commerce::Address.new params[:order][:shipping_address]
          new_customer.billing_address = Breeze::Commerce::Address.new params[:order][:billing_address]
          # TODO: Boolean for whether addresses are the same
          # TODO: Move this code out of the controller somehow
          if new_customer.save
            # set the order's customer
            @order.customer = new_customer
          end
        end

        if @order.save
          # TODO: Need a better way to reference order statuses
          # TODO: Store should not allow checkout if the appropriate order statuses don't exist yet
          @order.billing_status = Breeze::Commerce::OrderStatus.where(:type => :billing, :name => "Payment in process").first
          @order.save

          
          # Do payment with PxPay
          # TODO: Not sure what reference should be yet
          @payment = Breeze::Commerce::Payment.new(:name => @order.name, :email=> @order.email, :amount => @order.total, :reference => @order.id)
          if @payment.save and redirectable?
            redirect_to @payment.redirect_url and return
          else
            Rails.logger.debug @payment.errors.to_s.blue
            @payment.errors.each { |attrib, err| Rails.logger.debug attrib.to_s + ': ' + err.to_s }
          end
        else
          @customer = current_customer || Breeze::Commerce::Customer.new
          render :action => "checkout"
        end
      end

      def create
      end

      # Currently only need to update shipping method from shopping cart
      def update
        @order = current_order(session)
        # if params[:order].has_key? :shipping_method
        #   params[:order].delete(:shipping_method)
        # end
        @order.update_attributes params[:order]
        @order.save
      end 

      def thankyou 
        @payment = Payment.find params[:id]
        @payment.succeeded = true
        @payment.save
        @order = @payment.order
        @order.payment_completed = true # TODO: This should be redundant when we have a relation between a orders and payments
        @order.billing_status = Breeze::Commerce::OrderStatus.where(:type => :billing, :name => "Payment Received").first
        @order.save

        # Empty the cart
        session[:cart_id] = nil
      end

      def payment_failed
        @order = Order.find params[:id]
        flash[:error] = '<h4>Payment failed</h4><p>Unfortunately, your order didn\'t go through.</p>'.html_safe
        @customer = current_customer || Breeze::Commerce::Customer.new
        render :action => "checkout"
      end

    private

      # TODO: Move these private methods to a model – probably "order"
      # TODO: Replace hard-coded 'checkout' in url

      def pxpay_success
        @payment.update_pxpay_attributes request.params
        data[:_step] = self.next.name
        controller.redirect_to 'checkout'
      end

      def pxpay_failure
        @payment.update_pxpay_attributes request.params
        errors.add :base, "Couldn't process payment. Please try again."
        errors.add :base, "The payment server responded: #{@payment.pxpay_response_text}" if @payment.pxpay_response_text
      end

      def redirectable?
        @payment.pxpay_urls = pxpay_urls
        @payment.redirect_url.present?
      end

      def pxpay_urls
        {
          # :url_success => request.protocol + request.host_with_port + url_for( breeze.thankyou_order_path( current_order(session) ) ),
          :url_success => request.protocol + request.host_with_port + url_for( breeze.thankyou_order_path( @payment.id ) ),
          :url_failure => request.protocol + request.host_with_port + url_for( breeze.payment_failed_order_path( current_order(session) ) ),
        }
      end
    end
  end
end
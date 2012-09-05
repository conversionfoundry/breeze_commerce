module Breeze
  module Commerce
    class OrdersController < Breeze::Commerce::Controller
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

      # Add items to the order (i.e. the shopping cart)
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
        #product = Breeze::Commerce::Product.find(params[:product_id])
        #redirect_to product.permalink
        # @cart_content = 'bort' + render_partial( :partial => "partials/commerce/cart", :layout => false, :locals => {:order => @order} )

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
        
        # @order = store.orders.build params[:order]
        @order.update_attributes params[:order]
        
        if customer_signed_in?
          @order.customer = current_customer
        elsif params[:create_new_account]
          # create and save a new customer
          new_customer = Breeze::Commerce::Customer.new(
            :first_name => params[:order][:billing_address][:first_name],
            :last_name => params[:order][:billing_address][:last_name],
            :email => params[:order][:email],
            :password => params[:new_account_password],
            :password_confirmation => params[:new_account_password],
            :store => store
          )
          # TODO: Create customer shipping and billing addresses
          # TODO: Boolean for whether addresses are the same
          # TODO: Move this code out of the controller somehow
          if new_customer.save
            # set the order's customer
            @order.customer = new_customer
          end
        end

        if @order.save

          # Empty the cart
          session[:cart_id] = nil
          
          # Do payment with PxPay
          # TODO: Not sure what reference should be yet
          @payment = Breeze::PayOnline::Payment.new(:name => @order.name, :email=> @order.email, :amount => @order.total, :reference => @order.id)
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
        # @order = current_order(session)
      end

    private

      # TODO: Move these private methods to a model – probably "order"
      # TODO: Replace hard-coded 'checkout' in url

      # def pxpay_url
      #   request.protocol + request.host_with_port + '/payment' + '/' + @payment.id.to_s
      # end

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
          # :url_success => pxpay_url + '/pxpay_success',
          # :url_failure => pxpay_url + '/pxpay_failure',
          :url_success => request.protocol + request.host_with_port + url_for(breeze.thankyou_orders_path),
          :url_failure => request.protocol + request.host_with_port + url_for(breeze.checkout_path),
        }
      end
    end
  end
end
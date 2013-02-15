module Breeze
  module Commerce
    class OrdersController < Breeze::Commerce::Controller
      include Breeze::Commerce::CurrentOrder
      layout "breeze/commerce/checkout_funnel"
      respond_to :html, :js
      before_filter :require_nonempty_order, except: [:edit, :print, :update, :populate]

      def print
        @order = Order.find params[:id]
      end

      # This is currently here to make the checkout form work
      def show
      end

      # Displays the current cart
      def edit
        @order = current_order(session) || create_order(session)
        @countries = Breeze::Commerce::Country.order_by(:name.asc)
        shipping_methods = Breeze::Commerce::ShippingMethod.unarchived
        unless @order.shipping_method && shipping_methods.unarchived.include?(@order.shipping_method)
          if Breeze::Commerce::ShippingMethod.count > 1
            @order.shipping_method = shipping_methods.unarchived.where(:is_default => true).first
          else
            @order.shipping_method = shipping_methods.unarchived.first
          end
          @order.save
        end
      end

      def create
      end

      # Currently only need to update shipping method from shopping cart
      def update
        @order = current_order(session)
        @order.update_attributes params[:order]
        respond_to do |format|
          format.js
        end
      end 

      def checkout
        @order = current_order(session)
        @order.billing_status = Breeze::Commerce::OrderStatus.where(:type => :billing, :name => "Started Checkout").first
        @order.save
        @customer = current_store_customer || Breeze::Commerce::Customer.new
        @customer.shipping_address ||= Breeze::Commerce::Address.new
        @customer.billing_address ||= Breeze::Commerce::Address.new
        @allow_returning_customer_login = store.allow_returning_customer_login
        @countries = Breeze::Commerce::Country.order_by(:name.asc)
      end

      # Checkout completed, ready to process order
      def submit_order
        @order = current_order(session)

        # Set customer, if any
        if customer_signed_in?
          @order.customer = current_store_customer
        else
          if params[:create_new_account]
            @order.customer = create_customer(@order, params[:new_account_password], store)
          end
        end

        @order.update_attributes params[:order] # SHouldn't need this as well as save below
        @order.billing_status_id = Breeze::Commerce::OrderStatus.where(:type => :billing, :name => "Payment in process").first.id


        if @order.save          
          # Process payment with PxPay
          @payment = create_payment(@order, store)
          if @payment.save and redirectable?
            redirect_to @payment.redirect_url and return
          else
            Rails.logger.debug @payment.errors.to_s
            @payment.errors.each { |attrib, err| Rails.logger.debug attrib.to_s + ': ' + err.to_s }
            flash[:error] = "Sorry, we can't reach the payment gateway right now." # This error message might not be accurate!
            redirect_to breeze.checkout_path and return
          end
        else
          @customer = current_store_customer || Breeze::Commerce::Customer.new
          render :action => "checkout"
        end
      end

      def thankyou 
        @payment = Payment.find params[:id]
        @payment.succeeded = true
        @payment.save

        @order = @payment.order
        @order.payment_completed = true
        @order.billing_status = Breeze::Commerce::OrderStatus.where(:type => :billing, :name => "Payment Received").first
        @order.save

        # Send notification emails
        Breeze::Commerce::OrderMailer.new_order_merchant_notification(@order).deliver
        Breeze::Commerce::OrderMailer.new_order_customer_notification(@order).deliver

        unless store_customer_signed_in?
          if @order.customer
            sign_in @order.customer
          end
        end

        # Empty the cart
        session[:cart_id] = nil
      end

      def payment_failed
        @order = Order.find params[:id]
        flash[:error] = '<h4>Payment failed</h4><p>Unfortunately, your order didn\'t go through.</p>'.html_safe
        @customer = current_store_customer || Breeze::Commerce::Customer.new
        @customer.shipping_address ||= Breeze::Commerce::Address.new
        @customer.billing_address ||= Breeze::Commerce::Address.new
        @allow_returning_customer_login = store.allow_returning_customer_login
        render :action => "checkout"
      end

    private

      def require_nonempty_order
        @order = current_order(session) || create_order(session)
        if @order.line_items.empty?
          redirect_to breeze.cart_path
        end
      end

      def create_customer(order, password, store)
        new_customer = Breeze::Commerce::Customer.new(
          :first_name => order[:billing_address][:name].split(' ').first,
          :last_name => order[:billing_address][:name].split(' ').last,
          :email => order[:email],
          :password => password,
          :password_confirmation => password,
          :store => store
        )
        new_customer.shipping_address = Breeze::Commerce::Address.new params[:order][:shipping_address]
        new_customer.billing_address = Breeze::Commerce::Address.new params[:order][:billing_address]
        new_customer.save
      end

      def create_payment(order, store)
        Breeze::Commerce::Payment.new(
            name:       order.name, 
            email:      order.email, 
            amount:     order.total, 
            order:      order, 
            currency:   store.currency 
          )
      end

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
          :url_success => request.protocol + request.host_with_port + url_for( breeze.thankyou_order_path( @payment.id ) ),
          :url_failure => request.protocol + request.host_with_port + url_for( breeze.payment_failed_order_path( current_order(session) ) ),
        }
      end
    end
  end
end
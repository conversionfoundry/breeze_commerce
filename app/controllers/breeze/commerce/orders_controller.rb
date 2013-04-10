module Breeze
  module Commerce
    class OrdersController < Breeze::Commerce::Controller
      layout "breeze/commerce/checkout_funnel/checkout_funnel_layout"
      respond_to :html, :js
      before_filter :require_nonempty_order, except: [:create, :edit, :update, :populate, :thankyou]

      def show
        @order = Breeze::Commerce::Order.find(params[:id])
        @customer = Breeze::Commerce::Customer.new
        @allow_returning_customer_login = store.allow_returning_customer_login
        render "layouts/breeze/commerce/checkout_funnel/confirmation_page"
      end

      # Displays the current cart
      def edit
        @order = Breeze::Commerce::Order.find(params[:id])
        @countries = Breeze::Commerce::Shipping::Country.order_by(:name.asc)
        @shipping_methods = @order.country.shipping_methods.unarchived || Breeze::Commerce::Shipping::ShippingMethod.unarchived
        unless @order.shipping_method && @shipping_methods.unarchived.include?(@order.shipping_method)
          if Breeze::Commerce::Shipping::ShippingMethod.count > 1
            @order.shipping_method = @shipping_methods.unarchived.where(:is_default => true).first
          else
            @order.shipping_method = @shipping_methods.unarchived.first
          end
          @order.save
        end
      end

      def create
        if params[:old_order_id]
          @old_order = Breeze::Commerce::Order.find params[:old_order_id]
          @new_order = @old_order.duplicate_for_resend
          @new_order.save
          redirect_to breeze.checkout_order_path(@new_order)
        end
      end

      def update
        @order = Breeze::Commerce::Order.find params[:id]
        @order.update_attributes params[:order]
        @shipping_methods = @order.country.shipping_methods || Breeze::Commerce::Shipping::ShippingMethod.unarchived
        @countries = Breeze::Commerce::Shipping::Country.order_by(:name.asc)
        respond_to do |format|
          format.js
        end
      end 

      def redeem_coupon
        order = Breeze::Commerce::Order.find(params[:id])
        @coupon_code = Breeze::Commerce::Coupons::CouponCode.where(code: params[:code]).first
        if @coupon_code
          @code_redeemed = @coupon_code.redeem(order)
        end
      end

      def checkout
        @order = Breeze::Commerce::Order.find(params[:id])
        @order.billing_status = Breeze::Commerce::OrderStatus.where(:type => :billing, :name => "Started Checkout").first
        @order.save
        @customer = current_commerce_customer || Breeze::Commerce::Customer.new
        @customer.shipping_address ||= Breeze::Commerce::Address.new
        @customer.billing_address ||= Breeze::Commerce::Address.new
        @allow_returning_customer_login = store.allow_returning_customer_login
        @shipping_countries = Breeze::Commerce::Shipping::Country.order_by(:name.asc).map{|country| country.name}
        @billing_countries = Breeze::Commerce::COUNTRIES
        render "layouts/breeze/commerce/checkout_funnel/checkout_page"
      end

      def submit
        @order = Breeze::Commerce::Order.find(params[:id])
        # Set customer, if any
        if customer_signed_in?
          @order.customer = current_commerce_customer
        else
          if params[:create_new_account]
            @order.customer = create_customer(@order, params[:new_account_password], store)
          end
        end

        @order.update_attributes params[:order]
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
            redirect_to breeze.checkout_order_path and return
          end
        else
          @customer = current_commerce_customer || Breeze::Commerce::Customer.new
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
        @customer = current_commerce_customer || Breeze::Commerce::Customer.new

        # Send notification emails
        Breeze::Commerce::OrderMailer.new_order_merchant_notification(@order).deliver
        Breeze::Commerce::OrderMailer.new_order_customer_notification(@order).deliver

        unless commerce_customer_signed_in?
          if @order.customer
            sign_in @order.customer
          end
        end

        # Empty the cart
        session[:cart_id] = nil

        render "layouts/breeze/commerce/checkout_funnel/confirmation_page"
      end

      def payment_failed
        @order = Order.find params[:id]
        flash[:error] = '<h4>Payment failed</h4><p>Unfortunately, your order didn\'t go through.</p>'.html_safe
        @customer = current_commerce_customer || Breeze::Commerce::Customer.new
        @customer.shipping_address ||= Breeze::Commerce::Address.new
        @customer.billing_address ||= Breeze::Commerce::Address.new
        @allow_returning_customer_login = store.allow_returning_customer_login
        render :action => "checkout"
      end

    private

      def require_nonempty_order
        @order = Order.find params[:id]
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
          :url_failure => request.protocol + request.host_with_port + url_for( breeze.payment_failed_order_path( @order.id ) ),
        }
      end
    end
  end
end
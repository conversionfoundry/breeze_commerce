module Breeze
  module Commerce
    class OrdersController < Breeze::Commerce::Controller
      layout "breeze/commerce/checkout_funnel/checkout_funnel_layout"
      respond_to :html, :js
      # before_filter :check_permissions
      before_filter :find_order, except: [:create, :confirm_payment]
      before_filter :require_nonempty_order, except: [:create, :edit, :update, :confirm_payment]

      def show
        @customer = @order.customer || Breeze::Commerce::Customer.new
        @allow_returning_customer_login = store.allow_returning_customer_login
        render "layouts/breeze/commerce/checkout_funnel/confirmation_page"
      end

      def edit
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
        render "layouts/breeze/commerce/checkout_funnel/cart_page"
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
        @order.update_attributes params[:order]
        @shipping_methods = @order.country.shipping_methods.unarchived || Breeze::Commerce::Shipping::ShippingMethod.unarchived
        @countries = Breeze::Commerce::Shipping::Country.order_by(:name.asc)
        respond_to do |format|
          format.js
        end
      end

      def redeem_coupon
        @coupon_code = Breeze::Commerce::Coupons::CouponCode.where(code: params[:code]).first
        if @coupon_code
          @code_redeemed = @coupon_code.redeem(@order)
        end
      end

      def checkout
        @order.billing_status = Breeze::Commerce::Store.first.checkout_billing_status
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
        @order.update_attributes params[:order]
        @order.billing_status = Breeze::Commerce::Store.first.with_gateway_billing_status

        # Set customer, if any
        if customer_signed_in?
          @order.customer = current_commerce_customer
        else
          if params[:create_new_account]
            customer = Breeze::Commerce::Customer.new_with_information(@order, params[:new_account_password])
            customer.save
            @order.customer = customer
          end
        end

        if @order.save
          # Process payment with PxPay
          @payment = create_payment(@order, store)
          if @payment.save and redirectable?
            redirect_to @payment.redirect_url and return
          else
            Rails.logger.debug @payment.errors.to_s
            @payment.errors.each { |attrib, err| Rails.logger.debug attrib.to_s + ': ' + err.to_s }
            flash[:error] = "Sorry, we can't reach the payment gateway right now." # This error message might not be accurate!
            redirect_to breeze.checkout_order_path(@order) and return
          end
        else
          @customer = current_commerce_customer || Breeze::Commerce::Customer.new
          render"layouts/breeze/commerce/checkout_funnel/checkout_page"
        end
      end

      def confirm_payment
        @payment = Payment.find params[:id]
        @payment.update_attribute(:pxpay_response, Pxpay::Response.new(params).response.to_hash)
        @order = @payment.order
        @order.confirm_payment(@payment)

        unless commerce_customer_signed_in?
          if @order.customer
            sign_in @order.customer
          end
        end

        # Empty the cart
        session[:cart_id] = nil

        # Show the order
        redirect_to breeze.order_path(@order)
      end

      def payment_failed
        flash[:error] = '<h4>Payment failed</h4><p>Unfortunately, your order didn\'t go through.</p>'.html_safe
        @customer = current_commerce_customer || Breeze::Commerce::Customer.new
        @customer.shipping_address ||= Breeze::Commerce::Address.new
        @customer.billing_address ||= Breeze::Commerce::Address.new
        @allow_returning_customer_login = store.allow_returning_customer_login
        @shipping_countries = Breeze::Commerce::Shipping::Country.order_by(:name.asc).map{|country| country.name}
        @billing_countries = Breeze::Commerce::COUNTRIES
        render "layouts/breeze/commerce/checkout_funnel/checkout_page"
      end

    protected

      # def check_permissions
      #   begin
      #     @order = Order.find params[:id]
      #     authorize! :manage, @order
      #   rescue
      #     redirect_to Breeze::Commerce::Store.first.home_page.permalink
      #   end
      # end

    private

      def find_order
        @order ||= Order.find params[:id]
      end

      def require_nonempty_order
        @order = Order.find params[:id]
        if @order.line_items.empty?
          redirect_to breeze.edit_order_path(@order)
        end
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
          :url_success => request.protocol + request.host_with_port + url_for( breeze.confirm_payment_order_path( @payment.id ) ),
          :url_failure => request.protocol + request.host_with_port + url_for( breeze.payment_failed_order_path( @order.id ) ),
        }
      end
    end
  end
end
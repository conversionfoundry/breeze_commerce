module Breeze
  module Commerce
    class CustomersController < Breeze::Commerce::Controller
      helper Breeze::ContentsHelper
      layout "breeze/commerce/customer_profile"
      before_filter :check_permissions, except: [:new, :create]

      def new
        @customer = Breeze::Commerce::Customer.new
        @customer.shipping_address ||= Breeze::Commerce::Address.new
        @customer.billing_address ||= Breeze::Commerce::Address.new
      end
      
      def create
        @customer = Breeze::Commerce::Customer.new params[:customer]
        if @customer.save
          # set_flash_message(:notice, :customer_account_created)
          redirect_to store.home_page.permalink
        else
          if params[:customer][:order_id]
            @order = Breeze::Commerce::Order.find(params[:customer][:order_id])
            render "layouts/breeze/commerce/checkout_funnel/confirmation_page", layout: "breeze/commerce/checkout_funnel/checkout_funnel_layout"
          end
        end
      end

      def show
        @customer = Breeze::Commerce::Customer.find params[:id]
        @customer.shipping_address ||= Breeze::Commerce::Address.new
        @customer.billing_address ||= Breeze::Commerce::Address.new
        @billing_statuses = Breeze::Commerce::OrderStatus.billing
        @shipping_statuses = Breeze::Commerce::OrderStatus.shipping
        @new_order = Breeze::Commerce::Order.new
        @same_address = @customer.shipping_address == @customer.billing_address
        @shipping_countries = Breeze::Commerce::Country.order_by(:name.asc)
        @billing_countries = Breeze::Commerce::COUNTRIES
      end

      def update
        @customer = Breeze::Commerce::Customer.find params[:id]
        if @customer.update_attributes(params[:customer])
          redirect_to breeze.customer_path(@customer)
        else
          render :action => "edit"
        end
      end
      
      def destroy
        @customer = Breeze::Commerce::Customer.find(params[:id])
        @customer.orders.destroy_all
        @customer.try :destroy
      end

      protected

      def check_permissions
        begin
          @customer = Breeze::Commerce::Customer.find(params[:id])
          authorize! :manage, @customer
        rescue
          redirect_to Breeze::Commerce::Store.first.home_page.permalink
        end
      end

      private

      def current_ability
        @current_ability ||= Breeze::Admin::Ability.new(current_customer)
      end

    end
  end
end

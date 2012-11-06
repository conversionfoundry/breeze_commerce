module Breeze
  module Commerce
    class CustomersController < Breeze::Commerce::Controller
      helper Breeze::ContentsHelper
      layout "breeze/commerce/customer_profile"
      before_filter :check_permissions

      def new
        @customer = Breeze::Commerce::Customer.new
        @customer.shipping_address ||= Breeze::Commerce::Address.new
        @customer.billing_address ||= Breeze::Commerce::Address.new
      end
      
      def create
        @customer = Breeze::Commerce::Customer.build params[:customer]
        if @customer.save
          redirect_to breeze.customers_path
        else
          render :action => "new"
        end
      end

      def edit
        @customer = Breeze::Commerce::Customer.find params[:id]
        @customer.shipping_address ||= Breeze::Commerce::Address.new
        @customer.billing_address ||= Breeze::Commerce::Address.new
        @billing_statuses = Breeze::Commerce::OrderStatus.billing
        @shipping_statuses = Breeze::Commerce::OrderStatus.shipping
     end

      def update
        @customer = Breeze::Commerce::Customer.find params[:id]
        if @customer.update_attributes(params[:customer])
          redirect_to breeze.edit_customer_path(@customer)
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

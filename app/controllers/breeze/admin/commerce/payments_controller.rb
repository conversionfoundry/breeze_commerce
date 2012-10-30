module Breeze
  module Admin
    module Commerce
      class PaymentsController < Breeze::Admin::Commerce::Controller


        # Record a payment manually (i.e. without using a payment gateway)
        # This might be use to record a cash payment, or other orders processed offline
        def create
          @order = Breeze::Commerce::Order.find(params[:order_id])
          @payment = Breeze::Commerce::Payment.new(params[:payment])
          @payment.reference = @order.id
          @payment.created_by_merchant = true
          binding.pry
          @payment.save
        end

        def destroy
          @order = Breeze::Commerce::Order.find(params[:order_id])
          @payment = @order.payments.find params[:id]
          @payment.update_attributes(:archived => true)
        end

      end
    end
  end
end

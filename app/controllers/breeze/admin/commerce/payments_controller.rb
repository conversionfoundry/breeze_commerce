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
          # binding.pry
          @payment.save
        end

        def destroy
          @order = Breeze::Commerce::Order.find(params[:order_id])
          @payment = @order.payments.find params[:id]
          @payment.update_attributes(:archived => true)

          # TODO: also destroy all related options
        end

        # def edit
        #   @property = product.properties.find params[:id]
        # end

        # def update
        #   @property = product.properties.find params[:id]
        #   @property.update_attributes(:name => params[:property][:name])
        #   # TODO: also update options
          
        #   # Add any new options, and delete any removed ones
        #   param_options = params[:property][:option_names].split(',')
        #   param_options.each do |option_name|
        #     @property.options.create(:name => option_name) unless @property.options.where(:name => option_name).exists?
        #   end
        #   @property.options.each do |option|
        #     option.destroy unless param_options.include? option.name
        #   end
          
        #   # TODO: Need to check variants are still OK after properties and options change
          
        # end


      end
    end
  end
end

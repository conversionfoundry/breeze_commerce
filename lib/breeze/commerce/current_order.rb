module Breeze
  module Commerce
    module CurrentOrder 

      def current_order  # TODO: move this to a helper
        return @current_order if @current_order
        if (session[:cart_id])
          begin
            @current_order = Order.find(session[:cart_id])
          rescue
            create_order
          end
          # TODO: check if it has been purchased or not
        else
          create_order
        end

        @current_order
      end

      def create_order
        @current_order = Order.create! 
        # @current_order.shipping_method = ShippingMethod.first
        @current_order.save
        session[:cart_id] = @current_order.id
      end

    end
  end
end

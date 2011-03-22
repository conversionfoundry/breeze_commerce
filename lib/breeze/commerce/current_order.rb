module Breeze
  module Commerce
    module CurrentOrder 

      def current_order  # TODO: move this to a helper
        return @current_order if @current_order
        if (session[:cart_id])
          @current_order = Order.find(session[:cart_id])
          # TODO: check if it has been purchased or not
        else
          @current_order = Order.create!
          session[:cart_id] = @current_order.id
        end
        @current_order
      end

    end
  end
end

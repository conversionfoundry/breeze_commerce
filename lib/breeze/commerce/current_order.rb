module Breeze
  module Commerce
    module CurrentOrder 

      def current_order(session)  # TODO: move this to a helper
        return @current_order if @current_order
        if (session[:cart_id])
          begin
            @current_order = Order.find(session[:cart_id])
          rescue
            create_order(session)
          end
          # TODO: check if it has been purchased or not
        else
          # create_order(session)
        end
      
        @current_order
      end
      
      def create_order(session)
        @current_order = Breeze::Commerce::Order.create!(shipping_method: store.default_shipping_method)
        @current_order.save
        session[:cart_id] = @current_order.id
        return @current_order
      end

    end
  end
end

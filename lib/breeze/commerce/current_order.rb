module Breeze
  module Commerce
    module CurrentOrder 

      def current_order(session)
        return @current_order if @current_order
        if (session[:cart_id])
          begin
            @current_order = Order.find(session[:cart_id])
          rescue
            create_order(session)
          end
        else
          create_order(session)
        end
      
        @current_order
      end
      
      def create_order(session)
        @current_order = Breeze::Commerce::Order.new #(shipping_method: Breeze::Commerce::Store.first.default_shipping_method)
        @current_order.save
        session[:cart_id] = @current_order.id
        return @current_order
      end

    end
  end
end

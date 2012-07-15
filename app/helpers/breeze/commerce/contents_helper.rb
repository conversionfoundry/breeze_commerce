module Breeze
  module Commerce
    module ContentsHelper
      include Breeze::Commerce::CurrentOrder

      # def current_order  # TODO: move this to a helper
      #   return @current_order if @current_order
      #   if (session[:cart_id])
      #     begin
      #       @current_order = Order.find(session[:cart_id])
      #     rescue
      #       create_order
      #     end
      #     # TODO: check if it has been purchased or not
      #   else
      #     create_order
      #   end
      # 
      #   @current_order
      # end
      
      def cart
        @order = current_order(session)
        content_tag :div, link_to("My Cart", breeze.cart_path) + " " + number_to_currency(@order.total), :id => :cart
      end
    end
  end
end


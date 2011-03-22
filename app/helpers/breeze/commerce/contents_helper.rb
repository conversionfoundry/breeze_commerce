module Breeze
  module Commerce
    module ContentsHelper
      include Breeze::Commerce::CurrentOrder
      def cart
        @order = current_order
        content_tag :div, link_to("My Cart", cart_path) + " " + number_to_currency(@order.total), :id => :cart
      end
    end
  end
end


module Breeze
  module Commerce
    class LineItem
      include Mongoid::Document
      extend ActiveSupport::Memoizable

      embedded_in :order, :inverse_of => :line_items
      field :quantity, :type => Integer
      field :price_cents, :type => Integer
      # references_one :product
      references_one :variant

      def variant
        Variant.find(variant_id)
      end

      def product
        variant.product
      end
      
      def price
        (self.price_cents || 0) / 100.0
      end
      
      # memoize :product
      memoize :variant

      def amount
        self.variant.display_price * quantity
        # product.price * quantity
      end 
    end
  end
end

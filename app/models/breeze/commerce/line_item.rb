module Breeze
  module Commerce
    class LineItem
      include Mongoid::Document
      include Mixins::Archivable

      attr_accessible :quantity, :order, :order_id, :variant_id

      belongs_to :order, :class_name => "Breeze::Commerce::Order" , :inverse_of => :line_items # Ideally, this would be embedded, but we couldn't reference variant from an embedded line item
      belongs_to :variant, :class_name => "Breeze::Commerce::Variant"

      field :quantity, :type => Integer

      def name
        variant.name
      end
      
      def sku_code
        variant.sku_code
      end

      def product
        variant.product
      end
      
      def price_cents
        self.variant.display_price_cents || 0
      end

      def price
        (self.variant.display_price_cents || 0) / 100.0
      end
      
      def amount_cents
        self.variant.display_price_cents * quantity
      end 

      def amount
        self.variant.display_price * quantity
      end 
    end
  end
end

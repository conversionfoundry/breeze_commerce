module Breeze
  module Commerce
    class LineItem
      include Mongoid::Document

      attr_accessible :quantity, :archived

      belongs_to :order, :class_name => "Breeze::Commerce::Order" , :inverse_of => :line_items # Ideally, this would be embedded, but we couldn't reference variant from an embedded line item
      belongs_to :variant, :class_name => "Breeze::Commerce::Variant"

      field :quantity, :type => Integer
      field :archived, type: Boolean, default: false

      scope :archived, where(:archived => true)
      scope :unarchived, where(:archived.in => [ false, nil ])
      

      # def variant
      #   Variant.find(variant_id)
      # end

      def product
        variant.product
      end
      
      def price_cents
        self.variant.price_cents || 0
      end

      def price
        (self.variant.price_cents || 0) / 100.0
      end
      
      # memoize :variant

      def amount_cents
        self.variant.display_price_cents * quantity
        # product.price * quantity
      end 

      def amount
        self.variant.display_price * quantity
        # product.price * quantity
      end 
    end
  end
end

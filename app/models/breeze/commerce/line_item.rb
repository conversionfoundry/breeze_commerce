module Breeze
  module Commerce
    class LineItem
      include Mongoid::Document
      extend ActiveSupport::Memoizable

      belongs_to :order, :class_name => "Breeze::Commerce::Order" , :inverse_of => :line_items
      field :quantity, :type => Integer

      field :archived, type: Boolean, default: false

      scope :archived, where(:archived => true)
      scope :unarchived, where(:archived.in => [ false, nil ])
      
      belongs_to :variant, :class_name => "Breeze::Commerce::Variant"

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
      
      # memoize :product
      memoize :variant

      def amount
        self.variant.display_price * quantity
        # product.price * quantity
      end 
    end
  end
end

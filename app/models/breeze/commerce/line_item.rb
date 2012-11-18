module Breeze
  module Commerce
    class LineItem
      include Mongoid::Document
      include Mixins::Archivable

      attr_accessible :quantity, :order, :order_id, :variant_id, :variant

      belongs_to :order, :class_name => "Breeze::Commerce::Order" , :inverse_of => :line_items # Ideally, this would be embedded, but we couldn't reference variant from an embedded line item
      belongs_to :variant, :class_name => "Breeze::Commerce::Variant"

      field :quantity, type: Integer
      field :serialized_variant, type: Hash

      before_validation :serialize_variant

      validates :order, presence: true
      validates :variant, presence: true
      validates :serialized_variant, presence: true
      validates :quantity, presence: true, numericality: { greater_than: 0 }


      def name
        serialized_variant['name']
      end
      
      def sku_code
        serialized_variant['sku_code']
      end

      def product
        variant.product
      end
      
      def price_cents
        serialized_variant['discounted'] ? serialized_variant['discounted_sell_price_cents'] : serialized_variant['sell_price_cents']
      end

      def price
        (price_cents) / 100.0
      end
      
      def amount_cents
        price_cents * quantity
      end 

      def amount
        price * quantity
      end 

      private

      def serialize_variant
        if self.serialized_variant.nil? && variant
          self.serialized_variant = variant.attributes.dup
        end
      end
    end
  end
end

module Breeze
  module Commerce
    # Shipping method that allows a different shipping price if the total price of an order's line items is over a threshold amount
    # e.g. $10 shipping, or $5 shipping if your order is over $100
    # A common use case will be free shipping for orders over the threshold
    class ThresholdShippingMethod < Breeze::Commerce::ShippingMethod
      attr_accessible :threshold, :threshold_cents, :above_threshold_price, :above_threshold_price_cents

      # price_cents field from parent is used for the below-threshold price
      field :threshold_cents, :type => Integer
      field :above_threshold_price_cents, :type => Integer

      validates_presence_of :threshold_cents, :above_threshold_price_cents
      validates_numericality_of :threshold_cents, :above_threshold_price_cents
      validates_exclusion_of :threshold_cents, in: [0]

      def price_cents(order=nil)
        if order
          if order.item_total_cents < threshold_cents
            read_attribute(:price_cents)
          else
            above_threshold_price_cents
          end
        else
          read_attribute(:price_cents)
        end
      end

      def price(order=nil)
        if order 
          if order.item_total < threshold
              read_attribute(:price_cents).round / 100.0
          else
            above_threshold_price
          end
        else
          read_attribute(:price_cents).round / 100.0
        end
      end

      def threshold
        self.threshold_cents.round / 100.0
      end

      def threshold=(amount)
        self.threshold_cents = (amount.to_f  * 100).round
      end

      def above_threshold_price
        self.above_threshold_price_cents.round / 100.0
      end

      def above_threshold_price=(amount)
        self.above_threshold_price_cents = (amount.to_f  * 100).round
      end

      def price_explanation
        "$#{price}, or $#{above_threshold_price} for orders over $#{threshold}"
      end

    end
  end
end

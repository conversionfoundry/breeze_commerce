module Breeze
  module Commerce
    module Shipping
      # Shipping method that allows a different shipping price if any item in the order has a given tag
      # e.g. free shipping, or $5 shipping if your order includes an item tagged "clearance"
      class TagShippingMethod < Breeze::Commerce::Shipping::ShippingMethod
        attr_accessible :tag, :with_tag_price, :with_tag_price_cents

        # price_cents field from parent is used for the without-tag price
        field :with_tag_price_cents, :type => Integer
        belongs_to :tag, class_name: "Breeze::Commerce::Tag"

        validates_presence_of :tag, :with_tag_price_cents
        validates_numericality_of :with_tag_price_cents

        def self.human_readable_name
          "Flat rate shipping, depending on a tag"
        end

        def self.explanation
          "Two price tiers, depending on presence of a tag"
        end

        def price_cents(order=nil)
          if order
            if order.has_item_with_tag?(tag)
              with_tag_price_cents
            else
              read_attribute(:price_cents)
            end
          else
            read_attribute(:price_cents)
          end
        end

        def price(order=nil)
          if order
            if order.has_item_with_tag?(tag)
              with_tag_price
            else
              read_attribute(:price_cents).round / 100.0
            end
          else
            read_attribute(:price_cents).round / 100.0
          end
        end

        def with_tag_price
          self.with_tag_price_cents.round / 100.0
        end

        def with_tag_price=(amount)
          self.with_tag_price_cents = (amount.to_f  * 100).round
        end

        def price_explanation
          "$#{price}, or $#{with_tag_price} for orders where a product has tag #{tag.name}"
        end

      end
    end
  end
end

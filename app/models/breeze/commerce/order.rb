module Breeze
  module Commerce
    class Order
      include Mongoid::Document
      include Mongoid::Timestamps
      
      field :email
      field :subscribe, :type => Boolean
      field :gift, :type => Boolean
      field :personal_message

      # TODO: belongs_to :user
      embeds_many :line_items, :class_name => "Breeze::Commerce::LineItem"
      embeds_one :shipping_address, :class_name => "Breeze::Commerce::Address"
      embeds_one :billing_address, :class_name => "Breeze::Commerce::Address"
      references_one :shipping_method, :class_name => "Breeze::Commerce::ShippingMethod", :local_foreign_key => true

      def item_total
        line_items.map(&:amount).sum
      end

      def item_count
        line_items.map(&:quantity).sum
      end

      def shipping_total
        0  # TODO: calculate shipping
      end

      def total
        item_total + shipping_total
      end
    end
  end
end

module Breeze
  module Commerce
    class Order
      include Mongoid::Document
      include Mongoid::Timestamps
      
      field :email
      field :subscribe, :type => Boolean
      field :gift, :type => Boolean

      # TODO: belongs_to :user
      embeds_many :line_items, :class_name => "Breeze::Commerce::LineItem"
      embeds_one :shipping_address, :class_name => "Breeze::Commerce::Address"
      embeds_one :billing_address, :class_name => "Breeze::Commerce::Address"

      def item_total
        line_items.map(&:amount).sum
      end
    end
  end
end

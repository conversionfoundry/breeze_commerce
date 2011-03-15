module Breeze
  module Commerce
    class Order
      include Mongoid::Document
      include Mongoid::Timestamps

      # TODO: belongs_to :user
      embeds_many :line_items, :class_name => "Breeze::Commerce::LineItem"
      embeds_one :billing_address, :class_name => "Breeze::Commerce::Address"
    end
  end
end

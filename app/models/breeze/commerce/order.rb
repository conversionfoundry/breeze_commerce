module Breeze
  module Commerce
    class Order
      include Mongoid::Document
      include Mongoid::Timestamps

      # TODO: belongs_to :user
      embeds_many :line_items, :class_name => "Breeze::Commerce::LineItem"
    end
  end
end

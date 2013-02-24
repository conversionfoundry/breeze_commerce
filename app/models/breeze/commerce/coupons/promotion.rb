module Breeze
  module Commerce
    module Coupons
      class Promotion
        include Mongoid::Document

        field :name
        field :start_date, :type => Date
        field :end_date, :type => Date
        field :amount_value_cents, :type => Integer
        field :amount_type #fixed or percentage
        field :couponable_type #order, line_item, line_item_group, or shipping_method

        has_many :coupons
  			
      end
    end
  end
end

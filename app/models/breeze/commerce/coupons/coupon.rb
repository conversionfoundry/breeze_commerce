module Breeze
  module Commerce
    module Coupons
      class Coupon
        include Mongoid::Document

        attr_accessible :promotion
  
        field :code
        field :redemption_count, :type => Integer, default: 0
        field :max_redemptions, :type => Integer, default: 1

        belongs_to :promotion

        validates :code, presence: true
        validates :redemption_count, presence: true, numericality: true
        validates :max_redemptions, presence: true, numericality: true
        validates :promotion, presence: true
  			
  			def redeem(order)
          order.serialized_coupon = self.attributes.dup
          redemption_count += 1
          self.save
  			end

      end
    end
  end
end

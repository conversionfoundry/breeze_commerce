module Breeze
  module Commerce
    module Coupons
      class CouponCode
        include Mongoid::Document

        attr_accessible :coupon, :coupon_id, :code, :redemption_count, :max_redemptions
  
        field :code
        field :redemption_count, :type => Integer, default: 0
        field :max_redemptions, :type => Integer, default: 1

        belongs_to :coupon

        validates :code, presence: true
        validates :redemption_count, presence: true, numericality: true
        validates :coupon, presence: true
  			
        before_validation :generate_unique_code

  			def redeem(order)
          if can_redeem?
            order.serialize_coupon self.coupon
            self.redemption_count = self.redemption_count + 1
            self.save
          else
            return false
          end
  			end

        def generate_unique_code
          self.code ||= SecureRandom.base64(8).tr('+/=', '0aZ')
        end

        def can_redeem?
          if not self.coupon.can_redeem?
            return false
          else
            if max_redemptions == nil
              return true
            else
              redemption_count < max_redemptions
            end
          end
        end

      end
    end
  end
end

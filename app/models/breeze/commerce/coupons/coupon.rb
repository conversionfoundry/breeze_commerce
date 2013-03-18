module Breeze
  module Commerce
    module Coupons
      class Coupon
        include Mongoid::Document
        include Mongoid::MultiParameterAttributes

        attr_accessible :name, :start_time, :end_time, :discount_value, :discount_type, :couponable_type, :coupon_codes_attributes

        field :name
        field :start_time, type: Date
        field :end_time, type: Date
        field :discount_value, type: Integer #amount in cents or percentage
        field :discount_type, default: :fixed #fixed or percentage
        field :couponable_type, default: "Breeze::Commerce::Order" #order, line_item, line_item_group, or shipping_method

        has_many :coupon_codes, class_name: "Breeze::Commerce::Coupons::CouponCode", dependent: :destroy
        accepts_nested_attributes_for :coupon_codes, allow_destroy: true, reject_if: lambda { |cc| cc[:code].blank? }
        
        validates_presence_of :name, :start_time, :discount_value, :discount_type, :couponable_type

        def generate_coupon_codes number, code, max_redemptions
          number.times do |i|
            coupon_codes << Breeze::Commerce::Coupons::CouponCode.new( code: code, max_redemptions: max_redemptions )
          end
        end

        def days_left
          (self.end_time.to_date - Time.now.to_date + 1).to_i
        end

        def calculate_discount(order)
          discount_cents = case discount_type
          when :fixed
            discount_value
          when :percentage
            order.item_total_cents * (discount_value) / 100.0
          end
          (discount_cents) / 100.0
        end

        def can_redeem?
          (self.start_time..self.end_time).include? Time.now.to_date
        end

        def redemption_count
          coupon_codes.map(&:redemption_count).sum
        end

      end
    end
  end
end

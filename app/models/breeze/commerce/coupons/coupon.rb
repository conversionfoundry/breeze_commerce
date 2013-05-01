module Breeze
  module Commerce
    module Coupons
      class Coupon
        include Mongoid::Document
        include Mongoid::MultiParameterAttributes
        include Mixins::Archivable
        include Mixins::Publishable

        FILTERS = [
          {:scope => "all",         :label => "All Coupons"},
          {:scope => "published", :label => "Published Coupons"},
          {:scope => "unpublished", :label => "Unpublished Coupons"}
        ]

        attr_accessible :name, :start_time, :end_time, :discount_value, :discount_type, :couponable_type, :coupon_codes_attributes

        field :name
        field :start_time, type: DateTime
        field :end_time, type: DateTime
        field :discount_value, type: Integer #amount in dollars or percentage
        field :discount_type, default: :fixed #fixed or percentage
        field :couponable_type, default: "Breeze::Commerce::Order" #order, line_item, line_item_group, or shipping_method

        has_many :coupon_codes, class_name: "Breeze::Commerce::Coupons::CouponCode", dependent: :destroy
        accepts_nested_attributes_for :coupon_codes, allow_destroy: true, reject_if: lambda { |cc| cc[:code].blank? }

        validates_presence_of :name, :start_time, :discount_value, :couponable_type
        validates :discount_type, presence: true, :inclusion=> { in: [:fixed, :percentage] }
        validate :start_must_be_before_end_time

        def generate_coupon_codes number, code, max_redemptions
          number.times do
            coupon_codes << Breeze::Commerce::Coupons::CouponCode.new( code: code, max_redemptions: max_redemptions )
          end
        end

        def days_left
          (self.end_time.to_date - Time.zone.now.to_date + 1).to_i
        end

        def discount_cents(order)
          discount_cents = case discount_type
          when :fixed
            discount_value.to_f * 100
          when :percentage
            order.item_total_cents * (discount_value) / 100.0
          end
          discount_cents
        end

        def discount(order)
          ( discount_cents(order) ) / 100.0
        end

        def can_redeem?
          return false unless self.published
          if self.end_time
            (self.start_time..self.end_time).cover? Time.zone.now
          else
            self.start_time < Time.zone.now.to_date
          end
        end

        def redemption_count
          coupon_codes.map(&:redemption_count).sum
        end

      protected

        def start_must_be_before_end_time
          if end_time
            valid = start_time && start_time < end_time
          else
            valid = true
          end
          errors.add(:start_time, "must be before end time") unless valid
        end

      end
    end
  end
end

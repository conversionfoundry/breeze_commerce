require 'csv_shaper'

module Breeze
  module Admin
    module Commerce
      class CouponCodesController < Breeze::Admin::Commerce::Controller
        respond_to :csv

        def index
          if params[:coupon_id]
            @coupon_codes = Breeze::Commerce::Coupons::Coupon.find(params[:coupon_id]).coupon_codes.unscoped.includes(:coupon)
          else
            @coupon_codes = Breeze::Commerce::Coupons::CouponCode.unscoped.includes(:coupon)
          end
          respond_to do |format|
            format.csv 
          end
        end

      end
    end
  end
end

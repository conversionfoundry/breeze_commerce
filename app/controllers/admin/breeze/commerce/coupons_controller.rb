module Admin
  module Breeze
    module Commerce
      class CouponsController < Breeze::Commerce::Controller
        def index
          filters = params.select {|k,v| v.nil? }
          if filters.length > 0 
            @coupons = ::Breeze::Commerce::Coupon.send(filters.first[0].to_s)
          else
            @coupons = ::Breeze::Commerce::Coupon.all
          end
        end

        def new
          @coupon = Coupon.new
        end

        def create
          @coupon = Coupon.create params[:coupon]
        end
        
        def edit
          @coupon = Coupon.find params[:id]
        end
        
        def update
          @coupon = Coupon.find params[:id]
          @coupon.update_attributes params[:coupon]
        end
        
        def destroy
          @coupon = Coupon.find params[:id]
          @coupon.try :destroy
        end
      end
    end
  end
end

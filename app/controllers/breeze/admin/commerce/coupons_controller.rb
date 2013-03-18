module Breeze
  module Admin
    module Commerce
      class CouponsController < Breeze::Admin::Commerce::Controller
        helper_method :sort_method, :sort_direction

        def index
          @coupons = Breeze::Commerce::Coupons::Coupon.unscoped.includes(:coupon_codes).order_by(sort_method + " " + sort_direction)
          respond_to do |format|
            format.html
            format.json { render :json => @coupons.map{|c| { :id => c.id, :name => c.name } } }
          end
        end

        def new
          @coupon = Breeze::Commerce::Coupons::Coupon.new
        end

        def create
          @coupons = Breeze::Commerce::Coupons::Coupon.includes(:coupon_codes)
          @coupon_count = @coupons.count

          params[:coupon][:discount_type] = params[:coupon][:discount_type].to_sym

          if params[:end_never] == "true"
            params[:coupon].delete("end_time(1i)")
            params[:coupon].delete("end_time(2i)")
            params[:coupon].delete("end_time(3i)")
            params[:coupon].delete("end_time(4i)")
            params[:coupon].delete("end_time(5i)")
          end
          @coupon = Breeze::Commerce::Coupons::Coupon.create params[:coupon]

          if params[:coupon_type].to_sym == :repeated_use
            @coupon.generate_coupon_codes 1, params[:code], nil
          elsif params[:coupon_type].to_sym == :one_time_use
            @coupon.generate_coupon_codes params[:number_of_coupon_codes].to_i, nil, 1
          end 

        end
                
        def edit
          @coupon = Breeze::Commerce::Coupons::Coupon.find params[:id]
        end
        
        def update
          @coupon = Breeze::Commerce::Coupons::Coupon.find params[:id]
          params[:coupon][:discount_type] = params[:coupon][:discount_type].to_sym

          if params[:end_never] == "true"
            params[:coupon].delete("end_time(1i)")
            params[:coupon].delete("end_time(2i)")
            params[:coupon].delete("end_time(3i)")
            params[:coupon].delete("end_time(4i)")
            params[:coupon].delete("end_time(5i)")
            @coupon.end_time = nil
          end
          @coupon.update_attributes params[:coupon]

          if params[:coupon][:generate_10_codes]
            @coupon.generate_coupon_codes 10, nil, 1
          end

        end
        
        def reorder
          params[:coupon].each_with_index do |id, index|
            Breeze::Commerce::Coupons::Coupon.find(id).update_attributes :position => index
          end
          render :nothing => true
        end
        
        def destroy
          @coupon = Breeze::Commerce::Coupons::Coupon.find params[:id]
          @coupon.try :destroy
          @coupon_count = Breeze::Commerce::Coupons::Coupon.count
        end

      private

        def sort_method
          %w[name].include?(params[:sort]) ? params[:sort] : "name"
        end
        
        def sort_direction
          %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
        end

      end
    end
  end
end

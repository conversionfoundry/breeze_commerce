module Breeze
  module Admin
    module Commerce
      class CountriesController < Breeze::Admin::Commerce::Controller
        helper_method :sort_method, :sort_direction
       
        def index
          @countries = Breeze::Commerce::Shipping::Country.order_by(sort_method + " " + sort_direction)
        end

        def new
          @country = Breeze::Commerce::Shipping::Country.new
          @shipping_methods = Breeze::Commerce::Shipping::ShippingMethod.unarchived.order_by(:created_at.desc)
        end
        
        def create
          @countries = Breeze::Commerce::Shipping::Country.order_by(:name.asc)
          @country_count = @countries.count
          @country = Breeze::Commerce::Shipping::Country.create params[:country].merge({ position: @country_count })
          @shipping_methods = Breeze::Commerce::Shipping::ShippingMethod.unarchived.order_by(:created_at.desc)
        end

        def edit
          @country = Breeze::Commerce::Shipping::Country.find params[:id]
          @shipping_methods = Breeze::Commerce::Shipping::ShippingMethod.unarchived.order_by(:created_at.desc)
        end

        def update
          @country = Breeze::Commerce::Shipping::Country.find params[:id]
          @country.update_attributes params[:country]
          @countries = Breeze::Commerce::Shipping::Country.order_by(:name.asc)
        end

        def destroy
          @country = Breeze::Commerce::Shipping::Country.find params[:id]
          @country.try :destroy
          @country_count = Breeze::Commerce::Shipping::Country.count
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

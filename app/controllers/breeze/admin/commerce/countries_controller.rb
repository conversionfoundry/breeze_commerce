module Breeze
  module Admin
    module Commerce
      class CountriesController < Breeze::Admin::Commerce::Controller
        helper_method :sort_method, :sort_direction
       
        def index
          @countries = Breeze::Commerce::Country.order_by(:name.asc)
        end

        def new
          @country = Breeze::Commerce::Country.new
          @shipping_methods = Breeze::Commerce::ShippingMethod.unarchived.order_by(:created_at.desc)
        end
        
        def create
          @countries = Breeze::Commerce::Country.order_by(:name.asc)
          @country_count = @countries.count
          @country = Breeze::Commerce::Country.create params[:country].merge({ position: @country_count })
          @shipping_methods = Breeze::Commerce::ShippingMethod.unarchived.order_by(:created_at.desc)
        end

        def edit
          @country = Breeze::Commerce::Country.find params[:id]
          @shipping_methods = Breeze::Commerce::ShippingMethod.unarchived.order_by(:created_at.desc)
        end

        def update
          @country = Breeze::Commerce::Country.find params[:id]
          @country.update_attributes params[:country]
          @countries = Breeze::Commerce::Country.order_by(:name.asc)
        end

        def destroy
          @country = Breeze::Commerce::Country.find params[:id]
          @country.try :destroy
          @country_count = Breeze::Commerce::Country.count
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

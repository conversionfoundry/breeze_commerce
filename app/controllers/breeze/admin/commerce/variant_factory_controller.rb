module Breeze
  module Admin
    module Commerce
      class VariantFactoryController < Breeze::Admin::Commerce::Controller

        def new
          @product = Breeze::Commerce::Product.find params[:product_id]
        end

        def create
          @product = Breeze::Commerce::Product.find params[:product_id]
          binding.pry
          @errors = []
          if @product and not params[:variant_form_fields][:sell_price].blank?
            Breeze::Commerce::VariantFactory.instance.generate_variants @product, params[:variant_form_fields] #@product, sell_price
          else
            @errors << "Please include a sell price"
          end
        end

      end

    end

  end
end

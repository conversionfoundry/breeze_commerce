module Breeze
  module Admin
    module Commerce
      class VariantFactoryController < Breeze::Admin::Commerce::Controller

        def new
          @product = Breeze::Commerce::Product.find params[:product_id]
          @variant_factory = Breeze::Commerce::VariantFactory.instance
        end

        def create
          @product = Breeze::Commerce::Product.find params[:product_id]
          @errors = []
          if @product and not params[:variant_factory_fields][:sell_price].blank?
            Breeze::Commerce::VariantFactory.instance.generate_variants @product, params[:variant_factory_fields]
          else
            @errors << "Please include a sell price"
          end
        end

      end

    end

  end
end

module Breeze
  module Admin
    module Commerce
      class VariantsController < Breeze::Admin::Commerce::Controller
        def new
          @variant = product.variants.new
        end

        def create
          @variant = product.variants.create params[:variant]
          # TODO: Use accepts_nested_attributes_for in the model to tidy this up
          params[:options].each do |property, option_id|
            @variant.options << Breeze::Commerce::Option.find(option_id)
          end
        end

        def edit
          @variant = product.variants.find params[:id]
        end

        def update
          @variant = product.variants.find params[:id]
          # TODO: Use accepts_nested_attributes_for in the model to tidy this up
          params[:options].each do |property, option_id|
            @variant.options << Breeze::Commerce::Option.find(option_id)
          end
          @variant.update_attributes params[:variant]
          render :layout => false unless params[:Filename].blank?
        end

        private

        def product
          @product ||= ::Breeze::Commerce::Product.find params[:product_id]
        end
      end
    end
  end
end

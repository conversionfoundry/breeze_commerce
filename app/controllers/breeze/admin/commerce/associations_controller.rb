module Breeze
  module Admin
    module Commerce
      class AssociationsController < Breeze::Admin::Commerce::Controller
        def new
          @products = store.products.where(:_id.ne => product.id).where(:_id.nin => product.related_product_ids)
        end

        def create
          @association = store.products.find params[:association_id]
          product.related_products << @association
          product.save
        end

        # def create
        #   @variant = product.variants.create params[:variant]
        # end

        # def edit
        #   @variant = product.variants.find params[:id]
        # end

        # def update
        #   @variant = product.variants.find params[:id]
        #   @variant.update_attributes params[:variant]
        #   render :layout => false unless params[:Filename].blank?
        # end
        #
       def destroy
         @id = params[:id]
         product.related_product_ids.delete(@id)
         product.save
       end

        private

        def product
          @product ||= ::Breeze::Commerce::Product.find params[:product_id]
        end
      end
    end
  end
end


require 'carrierwave/mongoid'

module Breeze
  module Admin
    module Commerce
      class ProductImagesController < ::Breeze::Admin::AdminController

        def new
          @product_image = product.images.new
        end

        def create
          @product_image = product.images.create params[:product_image]
          @product_image.save
          # render partial: "breeze/admin/commerce/product_images/create", :object => @product_image, :layout => false, formats: [:js]
          redirect_to edit_admin_store_product_path(@product)
        end

        # def edit
        #   @product_image = Breeze::Commerce::ProductImage.find params[:id]
        # end

        def destroy
          @product_image = Breeze::Commerce::ProductImage.find params[:id]
          @product_image.try :destroy
        end

        # def reorder
        #   params[:image].each_with_index do |id, index|
        #     Image.find(id).update_attributes :position => index
        #   end
        #   render :nothing => true
        # end

        # TODO: Move this to a mixin, as we'll also use it elsewhere
        def reorder
          params[:product_image].each_with_index do |id, index|
            product.images.find(id).update_attributes :position => index
          end
          render :nothing => true
        end

        private

        def product
          @product ||= ::Breeze::Commerce::Product.find params[:product_id]
        end
      end
    end
  end
end

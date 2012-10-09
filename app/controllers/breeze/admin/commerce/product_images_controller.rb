module Breeze
  module Admin
    module Commerce
      class ProductImagesController < ::Breeze::Admin::AdminController

        def new
          @image = product.images.new
        end

        def create
          @image = product.images.create params[:product_image]
          @image.save
          redirect_to edit_admin_store_product_path product
        end

        def edit
          @image = Breeze::Commerce::ProductImage.find params[:id]
        end

        def destroy
          @image = Breeze::Commerce::ProductImage.find params[:id]
          @image.try :destroy
        end

        # def reorder
        #   params[:image].each_with_index do |id, index|
        #     Image.find(id).update_attributes :position => index
        #   end
        #   render :nothing => true
        # end

        private

        def product
          @product ||= ::Breeze::Commerce::Product.find params[:product_id]
        end
      end
    end
  end
end

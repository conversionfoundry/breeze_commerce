module Breeze
  module Admin
    module Commerce
      class ProductImagesController < ::Breeze::Admin::AdminController

        def new
          @image = product.images.new
        end

        def create
          # if (@image = ::Breeze::Commerce::ProductImage.where(:file => params[:Filename], :folder => params[:folder]).first)
          #   @image.file, @image.folder = params[:file], params[:folder]
          # else
          #   binding.pry
          #   @image ||= ::Breeze::Commerce::ProductImage.from_upload params
          #   @image.product = product
          #   @image.folder =  "images/products/#{@image.product.title}/"
          #   @image.position = @image.product.images.count
          # end
          # @image.save
          # respond_to do |format|
          #   format.html { render :partial => "breeze/admin/commerce/products/image", :object => @image, :layout => false }
          #   format.js
          # end

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

        def reorder
          params[:image].each_with_index do |id, index|
            Image.find(id).update_attributes :position => index
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

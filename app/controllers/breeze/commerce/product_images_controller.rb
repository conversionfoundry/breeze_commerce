module Breeze
  module Commerce
    class ProductImagesController < Breeze::Admin::AdminController


      def create
        if (@image = Breeze::Commerce::ProductImage.where(:file => params[:Filename], :folder => params[:folder]).first)
          @image.file, @image.folder = params[:file], params[:folder]
        else
          @image ||= Breeze::Commerce::ProductImage.from_upload params
          @image.product = product
          @image.folder =  "images/products/#{@image.product.name}/"
          @image.position = @image.product.images.count
        end
        @image.save
        respond_to do |format|
          format.html { render :partial => "/breeze/commerce/products/image", :object => @image, :layout => false }
          format.js
        end
      end

      def edit
        @image = Breeze::Gallery::Image.find params[:id]
      end

      def destroy
        @image = Breeze::Gallery::Image.find params[:id]
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
        @product ||= Product.find params[:product_id]
      end
    end
  end
end


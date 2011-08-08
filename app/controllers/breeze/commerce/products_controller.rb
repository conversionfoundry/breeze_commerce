module Breeze
  module Commerce
    class ProductsController < Breeze::Commerce::Controller
      def index
        @products = Product.all
      end
      
      def new
        @product = Product.new
      end
      
      def create
        @product = Product.new params[:product]
        if @product.save
          redirect_to admin_store_products_path
        else
          render :action => "new"
        end
      end

      def edit
        @product = Product.find params[:id]
      end

      def update
        @product = Product.find params[:id]
        if @product.update_attributes(params[:product])
          flash[:notice] = "The product was saved. <a href=\"#{@product.permalink}\">View your changes</a>, <a href=\"#{admin_store_products_path}\">return to the list of products</a>, or close this message to continue editing."
          redirect_to edit_admin_store_product_path(@product)
        else
          render :action => "edit"
        end
      end
    end
  end
end

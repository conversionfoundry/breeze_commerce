# module Breeze
#   module Commerce
#     class ProductsController < Breeze::Commerce::Controller
#       layout "breeze/commerce/product"
#       include Breeze::Commerce::ContentsHelper
#       
#       def index
#         @products = store.products
#       end
#       
#       def new
#         @product = store.products.build
#       end
#       
#       def create
#         @product = store.products.build params[:product]
#         if @product.save
#           redirect_to admin_store_products_path
#         else
#           render :action => "new"
#         end
#       end
# 
#       def edit
#         @product = store.products.find params[:id]
#       end
#       
#       def update
#         @product = store.products.find params[:id]
#         if @product.update_attributes(params[:product])
#           flash[:notice] = "The product was saved. <a href=\"#{@product.permalink}\">View your changes</a>, <a href=\"#{admin_store_products_path}\">return to the list of products</a>, or close this message to continue editing."
#           redirect_to edit_admin_store_product_path(@product)
#         else
#           render :action => "edit"
#         end
#       end
#     end
#   end
# end
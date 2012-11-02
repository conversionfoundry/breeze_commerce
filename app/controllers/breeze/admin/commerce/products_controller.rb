module Breeze
  module Admin
    module Commerce
      class ProductsController < Breeze::Admin::Commerce::Controller
        def index
          @products = Breeze::Commerce::Product.unarchived.where(:store_id => store.id).order_by(:created_at.desc)
        end
        
        def new
          # New products appear by default as children of the site's root page.
          # Note that new products are hidden from navigation by default, so it's OK to add new products without screwing up menus.
          @product = Breeze::Commerce::Product.new parent_id: Breeze::Content::Page.root.first.id
        end
        
        def create
          @product = Breeze::Commerce::Product.build params[:product]
          if @product.save
            # redirect_to admin_store_products_path
            redirect_to edit_admin_store_product_path(@product)
          else
            render :action => "new"
          end
        end

        def edit
          @product = Breeze::Commerce::Product.find params[:id]
        end

        def update
          @product = Breeze::Commerce::Product.find params[:id]
          if @product.update_attributes(params[:product])
            flash[:notice] = "The product was saved. <a href=\"#{@product.permalink}\">View your changes</a>, <a href=\"#{admin_store_products_path}\">return to the list of products</a>, or close this message to continue editing."
            redirect_to edit_admin_store_product_path(@product)
          else
            render :action => "edit"
          end
        end
        
        # Products are never destroyed, only archived.
        # TODO: Rename this method? It will make the routes a little mroe complicated
        def destroy
          @product = Breeze::Commerce::Product.find params[:id]
          @product.update_attributes(:archived => true)
          @product_count = Breeze::Commerce::Product.unarchived.count
        end

        def mass_update
          @products = Breeze::Commerce::Product.find params[:product_ids]
          @products.each do |product|
            product.update_attributes params[:product]
          end
        end
        
        # TODO: Merge with update
        def set_default_image
          @product = Breeze::Commerce::Product.find params[:id]
          @product_image = @product.images.find params[:product_image]
          @product.default_image = @product_image
          @product.save
        end

        def mass_destroy
          @products = Breeze::Commerce::Product.find params[:product_ids]
          @products.each do |product|
            product.update_attributes(:archived => true)
          end
          @product_count = Breeze::Commerce::Product.unarchived.count
        end

      end
    end
  end
end

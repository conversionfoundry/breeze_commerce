module Breeze
  module Admin
    module Commerce
      class ProductsController < Breeze::Admin::Commerce::Controller
        def index
          @products = Breeze::Commerce::Product.unarchived.where(:store_id => store.id).order_by(:created_at.desc).paginate(:page => params[:page], :per_page => 15)
        end
        
        def new
          # New products appear by default as children of the site's root page.
          # Note that new products are hidden from navigation by default, so it's OK to add new products without screwing up menus.
          @product = store.products.new parent_id: Breeze::Content::Page.root.first.id
        end
        
        def create
          @product = store.products.build params[:product]
          if @product.save
            # redirect_to admin_store_products_path
            redirect_to edit_admin_store_product_path(@product)
          else
            render :action => "new"
          end
        end

        def edit
          @product = store.products.find params[:id]
        end

        def update
          @product = store.products.find params[:id]
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
          @product = store.products.find params[:id]
          @product.update_attributes(:archived => true)
        end

        def mass_update
          @products = store.products.find params[:product_ids]
          @products.each do |product|
            product.update_attributes params[:product]
          end
        end
        
        def mass_destroy
          @products = store.products.find params[:product_ids]
          @products.each do |product|
            product.update_attributes(:archived => true)
          end
        end

      end
    end
  end
end

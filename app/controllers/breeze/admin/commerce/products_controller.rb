module Breeze
  module Admin
    module Commerce
      class ProductsController < Breeze::Admin::Commerce::Controller
        def index
          @products = Breeze::Commerce::Product.unarchived.where(:store_id => store.id).order_by(:created_at.desc).paginate(:page => params[:page], :per_page => 15)
        end
        
        def new
          @product = store.products.new
        end
        
        def create
          @product = store.products.build params[:product]
          if @product.save
          # if @product = store.products.create(params[:product])
            redirect_to admin_store_products_path
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

      end
    end
  end
end

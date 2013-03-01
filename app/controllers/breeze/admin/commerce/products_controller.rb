module Breeze
  module Admin
    module Commerce
      class ProductsController < Breeze::Admin::Commerce::Controller
        helper_method :sort_method, :sort_direction

        def index
          @products = Breeze::Commerce::Product.unscoped.includes(:variants).unarchived.order_by(sort_method + " " + sort_direction).paginate(:page => params[:page], :per_page => 15)
        end
        
        def new
          # New products appear by default as children of the site's root page.
          # Note that new products are hidden from navigation by default, so it's OK to add new products without screwing up menus.
          @product = Breeze::Commerce::Product.new parent_id: Breeze::Content::Page.root.first.id
        end
        
        def create
          @product = Breeze::Commerce::Product.new params[:product]
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

      private

        def sort_method
          %w[title published updated_at].include?(params[:sort]) ? params[:sort] : "title"
        end
        
        def sort_direction
          %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
        end

      end
    end
  end
end

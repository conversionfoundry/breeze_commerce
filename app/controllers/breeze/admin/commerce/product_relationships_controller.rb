module Breeze
  module Admin
    module Commerce
      class ProductRelationshipsController < Breeze::Admin::Commerce::Controller
        def new
          @product = product
          @products = store.products.unarchived.where(:_id.ne => product.id)#.where(:_id.nin => product.related_product_ids)
          @product_relationship = product.product_relationship_children.new
        end

        def create
          @product_relationship = product.product_relationship_children.create(params[:product_relationship])
        end

        def edit
          @product = product
          @products = store.products.unarchived.where(:_id.ne => product.id)#.where(:_id.nin => product.related_product_ids)
          @product_relationship = product.product_relationship_children.find params[:id]
        end

        def update
          @product_relationship = product.product_relationship_children.find params[:id]
          @product_relationship.update_attributes params[:product_relationship]
        end
        
       def destroy
        @product_relationship = product.product_relationship_children.find params[:id]
        @product_relationship.try :destroy
       end

        private

        def product
          @product ||= ::Breeze::Commerce::Product.find params[:product_id]
        end
      end
    end
  end
end


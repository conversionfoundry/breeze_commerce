module Breeze
  module Admin
    module Commerce
      class VariantsController < Breeze::Admin::Commerce::Controller
        respond_to :html, :js

        def new
          @variant = product.variants.new
        end

        def create
          @variant = product.variants.create params[:variant]
          if params[:options]
            params[:options].each do |property, option_id|
              @variant.options << Breeze::Commerce::Option.find(option_id)
            end
          end
          if @variant.save
            redirect_to edit_admin_store_product_path(product)
          end
        end

        def edit
          @variant = product.variants.find params[:id]
        end

        def update
          @variant = product.variants.find params[:id]
          if params[:options]
            @variant.options = []
            params[:options].each do |property, option_id|
              @variant.options << Breeze::Commerce::Option.find(option_id)
            end
          end
          if @variant.update_attributes(params[:variant])
            respond_to do |format|
              format.html { redirect_to edit_admin_store_product_path(product) }
              format.js
            end
          end
        end

        def destroy
          @variant = product.variants.find params[:id]
          @variant.update_attribute(:archived, true)
        end

        def reorder
          params[:variant].each_with_index do |id, index|
            Breeze::Commerce::Variant.find(id).update_attribute( :position, index )
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

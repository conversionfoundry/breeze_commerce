module Breeze
  module Admin
    module Commerce
      class VariantsController < Breeze::Admin::Commerce::Controller

        def new
          @variant = product.variants.new
        end

        def create
          @variant = product.variants.create params[:variant]
          # TODO: Use accepts_nested_attributes_for in the model to tidy this up
          if params[:options] 
            params[:options].each do |property, option_id|
              @variant.options << Breeze::Commerce::Option.find(option_id)
            end
          end
          if @variant.save
            redirect_to edit_admin_store_product_path(product)
          else
            render :action => "new"
          end
        end

        def edit
          @variant = product.variants.find params[:id]
        end

        def update
          @variant = product.variants.find params[:id]
          # TODO: Use accepts_nested_attributes_for in the model to tidy this up
          if params[:options]
            params[:options].each do |property, option_id|
              @variant.options << Breeze::Commerce::Option.find(option_id)
            end
          end
          @variant.update_attributes(params[:variant])
        end

        def destroy
          @variant = product.variants.find params[:id]
          @variant.update_attributes(:archived => true)
        end

        private

        def product
          @product ||= ::Breeze::Commerce::Product.find params[:product_id]
        end
      end
    end
  end
end

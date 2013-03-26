module Breeze
  module Admin
    module Commerce
      class PropertiesController < Breeze::Admin::Commerce::Controller
        respond_to :html, :js

        def new
          @property = product.properties.new
          3.times { @property.options.build }
        end

        def create
          @property = product.properties.create(params[:property])
          if @property.errors.any?
            3.times { @property.options.build }
          end
        end

        def edit
          @property = product.properties.find params[:id]
        end

        def update
          @property = product.properties.find params[:id]
          @property.update_attributes(params[:property])
        end

        def destroy
          @property = product.properties.find params[:id]
          @property.try :destroy
        end

        private

        def product
          @product ||= ::Breeze::Commerce::Product.find params[:product_id]
        end
      end
    end
  end
end

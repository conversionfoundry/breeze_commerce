module Breeze
  module Admin
    module Commerce
      class PropertiesController < Breeze::Admin::Commerce::Controller
        def new
          @property = product.properties.new
        end

        def create
          @property = product.properties.create(:name => params[:property][:name])
          params[:property][:option_names].split(',').each do |option_name|
            @property.options.create(:name => option_name)
          end
        end

        def edit
          @property = product.properties.find params[:id]
        end

        def update
          @property = product.properties.find params[:id]
          @property.update_attributes(:name => params[:property][:name])
          # TODO: also update options
          
          # Add any new options, and delete any removed ones
          param_options = params[:property][:option_names].split(',')
          param_options.each do |option_name|
            @property.options.create(:name => option_name) unless @property.options.where(:name => option_name).exists?
          end
          @property.options.each do |option|
            option.destroy unless param_options.include? option.name
          end
          
          # TODO: Need to check variants are still OK after properties and options change
          
        end

        def destroy
          @property = product.properties.find params[:id]
          @property.try :destroy
          # TODO: also destroy all related options
        end

        private

        def product
          @product ||= ::Breeze::Commerce::Product.find params[:product_id]
        end
      end
    end
  end
end

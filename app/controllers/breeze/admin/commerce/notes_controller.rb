module Breeze
  module Admin
    module Commerce
      class NotesController < Breeze::Admin::Commerce::Controller

        def create
          @order = Breeze::Commerce::Order.find(params[:order_id])
          @note = @order.notes.create!(params[:note])
          # redirect_to edit_admin_store_order_path, :notice => "Note created!" # TODO: The path isn't working.
        end

        # def edit
        #   @property = product.properties.find params[:id]
        # end

        # def update
        #   @property = product.properties.find params[:id]
        #   @property.update_attributes(:name => params[:property][:name])
        #   # TODO: also update options
          
        #   # Add any new options, and delete any removed ones
        #   param_options = params[:property][:option_names].split(',')
        #   param_options.each do |option_name|
        #     @property.options.create(:name => option_name) unless @property.options.where(:name => option_name).exists?
        #   end
        #   @property.options.each do |option|
        #     option.destroy unless param_options.include? option.name
        #   end
          
        #   # TODO: Need to check variants are still OK after properties and options change
          
        # end

        def destroy
          @order = Breeze::Commerce::Order.find(params[:order_id])
          @note = @order.notes.find params[:id]
          @note.try :destroy
        end


      end
    end
  end
end

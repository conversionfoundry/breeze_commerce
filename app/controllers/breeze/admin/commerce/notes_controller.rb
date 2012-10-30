module Breeze
  module Admin
    module Commerce
      class NotesController < Breeze::Admin::Commerce::Controller

        def create
          @order = Breeze::Commerce::Order.find(params[:order_id])
          @note = @order.notes.create!(params[:note])
        end

        def destroy
          @order = Breeze::Commerce::Order.find(params[:order_id])
          @note = @order.notes.find params[:id]
          @note.try :destroy
        end


      end
    end
  end
end

module Breeze
  module Admin
    module Commerce
      class StoresController < Breeze::Admin::Commerce::Controller

        def edit
        end

        def update
          store.update_attributes params[:store]
          redirect_to :back
        end

      end
    end
  end
end

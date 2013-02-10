module Breeze
  module Admin
    module Commerce
      class StoresController < Breeze::Admin::Commerce::Controller

        # Set up a basic store
        # TODO: This is really duplicating the install generator. It should all be in seeds. Likewise for breeze_blog
        def create
          store = Breeze::Commerce::Store.first || Breeze::Commerce::Store.create
          redirect_to admin_store_root_path
        end

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

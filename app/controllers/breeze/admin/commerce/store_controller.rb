module Breeze
  module Admin
    module Commerce
      class StoreController < Breeze::Admin::Commerce::Controller

        # Set up a basic store
        # TODO: This is really duplicating the install generator. It should all be in seeds. Likewise for breeze_blog
        def setup_default
          store = Breeze::Commerce::Store.first || Breeze::Commerce::Store.create

          redirect_to admin_store_root_path
        end

        def index
          @top_customers = store.customers.all.sort { |a,b| a.order_total <=> b.order_total }.reverse.paginate :page => 1, :per_page => 10
        end
        
        def settings
          if request.put?
            if store.update_attributes params[:store]
              redirect_to admin_store_settings_path
            else
              render :action => "settings"
            end
          end
        end
      end
    end
  end
end

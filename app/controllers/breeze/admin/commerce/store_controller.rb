module Breeze
  module Admin
    module Commerce
      class StoreController < Breeze::Admin::Commerce::Controller
        def index
          # @recent_comments = blog.comments.not_spam.most_recent(5)
        end
        
        # TODO: Test this code
        def setup_default
          @store = Store.new :title => "Store", :parent_id => Breeze::Content::NavigationItem.root.first.try(:id)
          @store.save!
          redirect_to admin_store_root_path
        end
        
        def switch
          session[:store_id] = params[:store]
          redirect_to :action => "index"
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

module Breeze
  module Admin
    module Commerce
      class StoreController < Breeze::Admin::Commerce::Controller
        def index
          # @recent_comments = blog.comments.not_spam.most_recent(5)
          @top_customers = store.customers.all.sort { |a,b| a.order_total <=> b.order_total }.reverse.paginate :page => 1, :per_page => 10
        end
        
        def settings
          if request.put?
            if store.update_attributes params[:store]
            # store.home_page_id = Breeze::Content::Page.find(params[:store][:home_page_id]).id
            # if store.save
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

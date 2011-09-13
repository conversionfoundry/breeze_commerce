module Admin
  module Breeze
    module Commerce
      class StoreController < Admin::Breeze::Commerce::Controller
        def index
          # @recent_comments = blog.comments.not_spam.most_recent(5)
        end
        
        def setup_default
          @blog = Blog.new :title => "Blog", :parent_id => Breeze::Content::NavigationItem.root.first.try(:id)
          @blog.save!
          redirect_to admin_blog_root_path
        end
        
        def switch
          session[:blog_id] = params[:blog]
          redirect_to :action => "index"
        end
        
        def new_spam_strategy
          
        end
        
        def settings
          if request.put?
            if blog.update_attributes params[:blog]
              redirect_to admin_blog_settings_path
            else
              render :action => "settings"
            end
          end
        end
      end
    end
  end
end

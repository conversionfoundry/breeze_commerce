module Breeze
  module Commerce
    class Controller < Breeze::Admin::AdminController
      helper Breeze::Commerce::CommerceAdminHelper
      # helper Breeze::Blog::BlogHelper
      #before_filter :check_for_blogs, :except => [ :setup_default ]

    protected
      #def check_for_blogs
      #  unless blog
      #    render :action => "no_blog"
      #  end
      #end

      #def blog
      #  @blog ||= if session[:blog_id].present?
       #   Breeze::Blog::Blog.where(:_id => session[:blog_id]).first
       # end || Breeze::Blog::Blog.first
       # session[:blog_id] = @blog.try(:id)
       # @blog
      #end
     # helper_method :blog
    end
  end
end

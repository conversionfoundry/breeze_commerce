module Breeze
  module Commerce
    class ProductsController < Breeze::Commerce::Controller
      def index
        @products = Product.all
      end
      
      def scheduled
        render :partial => "posts", :locals => { :posts => blog.posts.pending.paginate(:page => params[:page], :per_page => 10), :view => :pending }, :layout => false
      end
      
      def published
        render :partial => "posts", :locals => { :posts => blog.posts.published.paginate(:page => params[:page], :per_page => 10), :view => :published }, :layout => false
      end
      
      def show
        if (@post = blog.posts.find params[:id])
          redirect_to @post.permalink
        end
      end
      
      def new
        @product = Product.new
      end
      
      def create
        @product = Product.new params[:product]
        if @product.save
          redirect_to admin_commerce_products_path
        else
          render :action => "new"
        end
      end
      
      def edit
        @post = blog.posts.find params[:id]
      end
      
      def update
        @post = blog.posts.find params[:id]
        if @post.update_attributes(params[:post])
          flash[:notice] = "Your post was saved. <a href=\"#{@post.permalink}\">View your changes</a>, <a href=\"#{admin_blog_posts_path}\">return to the list of posts</a>, or close this message to continue editing."
          redirect_to edit_admin_blog_post_path(@post)
        else
          render :action => "edit"
        end
      end 
    end
  end
end

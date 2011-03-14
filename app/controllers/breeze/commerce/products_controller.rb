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
      
    end
  end
end

module Breeze
  module Commerce
    class ProductsController < Breeze::Commerce::Controller
      def index
        @product_list = Breeze::Commerce::ProductList.find(params[:product_list_id])
        @products = @product_list.products #.paginate(:page => params[:page], :per_page => 3)
        @page = params[:page]
      end
    end
  end
end

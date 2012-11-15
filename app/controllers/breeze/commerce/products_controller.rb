module Breeze
  module Commerce
    class ProductsController < Breeze::Commerce::Controller
      def index
        @product_list = Breeze::Commerce::ProductList.includes(:tags).find(params[:product_list_id])
        @products = Kaminari.paginate_array(@product_list.products).page(params[:page]).per(@product_list.products_per_page)
      end
    end
  end
end

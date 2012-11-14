module Breeze
  module Commerce
    class ProductsController < Breeze::Commerce::Controller
      def index
        @product_list = Breeze::Commerce::ProductList.includes(:tags).find(params[:product_list_id])
        page_number = params[:page_number]||1
        @products = Kaminari.paginate_array(@product_list.products).page(page_number).per(1)
      end
    end
  end
end

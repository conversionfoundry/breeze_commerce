module Breeze
  module Commerce
    class LineItem
      include Mongoid::Document
      extend ActiveSupport::Memoizable

      embedded_in :order, :inverse_of => :line_items
      field :quantity, :type => Integer
      references_one :product

      def product
        Product.find(product_id)
      end
      memoize :product 
    end
  end
end

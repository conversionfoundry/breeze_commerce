module Breeze
  module Commerce
    class LineItem
      include Mongoid::Document

      embedded_in :order, :inverse_of => :line_items
      field :quantity, :type => Integer
      references_one :product
    end
  end
end

module Breeze
  module Commerce
    class ShippingMethod
      include Mongoid::Document

      field :description
      field :price, :type => Integer
    end
  end
end

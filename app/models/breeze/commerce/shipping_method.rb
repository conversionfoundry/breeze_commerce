module Breeze
  module Commerce
    class ShippingMethod
      include Mongoid::Document

      identity :type => String

      field :description
      field :price, :type => Integer


    end
  end
end

module Breeze
  module Commerce
    class ShippingMethod
      include Mongoid::Document

      belongs_to_related :store, :class_name => "Breeze::Commerce::Store", :inverse_of => :shipping_methods
      has_many_related :orders, :class_name => "Breeze::Commerce::Order", :inverse_of => :shipping_methods

      identity :type => String

      field :name
      field :price, :type => Integer


    end
  end
end

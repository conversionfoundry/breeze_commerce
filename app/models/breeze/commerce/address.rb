module Breeze
  module Commerce
    class Address
      include Mongoid::Document

      embedded_in :order, :class_name => "Breeze::Commerce::Order", :inverse_of => :shipping_address
      
      field :first_name
      field :last_name
      field :phone
      field :country
    end
  end
end

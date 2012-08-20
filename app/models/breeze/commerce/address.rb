module Breeze
  module Commerce
    class Address
      include Mongoid::Document

      embedded_in :order, :class_name => "Breeze::Commerce::Order", :inverse_of => :shipping_address
      
      field :first_name
      field :last_name
      field :phone
      field :country

      def name
        first_name.to_s + ' ' + last_name.to_s
      end

      def to_html
        name + '<br />' + country.to_s
      end
    end
  end
end

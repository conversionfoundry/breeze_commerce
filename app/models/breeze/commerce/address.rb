module Breeze
  module Commerce
    class Address
      include Mongoid::Document

      embedded_in :order, :class_name => "Breeze::Commerce::Order", :inverse_of => :shipping_address
      
      field :name
      field :address # May be multi-line
      field :city
      field :state
      field :postcode
      field :country
      field :phone

      def to_html
        if name and country
          name + '<br />' + country.to_s
        else
          'missing data'
        end
      end
    end
  end
end

module Breeze
  module Commerce
    module Shipping

      class Country
        include Mongoid::Document

        has_and_belongs_to_many :shipping_methods, :class_name => "Breeze::Commerce::Shipping::ShippingMethod"

        attr_accessible :name, :shipping_method_ids
        field :name
        validates_presence_of :name, :shipping_method_ids, message: "Please select one or more shipping methods for this country."
      end

    end
  end
end

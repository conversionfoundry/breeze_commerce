module Breeze
  module Commerce
    class Country
      include Mongoid::Document

      has_and_belongs_to_many :shipping_methods, :class_name => "Breeze::Commerce::ShippingMethod"

      attr_accessible :name, :shipping_method_ids
      field :name
      validates_presence_of :name, :shipping_method_ids

    end
  end
end

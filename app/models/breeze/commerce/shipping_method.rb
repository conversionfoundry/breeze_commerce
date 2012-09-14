module Breeze
  module Commerce
    class ShippingMethod
      include Mongoid::Document

      belongs_to_related :store, :class_name => "Breeze::Commerce::Store", :inverse_of => :shipping_methods
      has_many_related :orders, :class_name => "Breeze::Commerce::Order", :inverse_of => :shipping_methods

      identity :type => String

      field :name
      field :description
      field :price, :type => Integer
      field :archived, type: Boolean, default: false

      scope :archived, where(:archived => true)
      scope :unarchived, where(:archived.in => [ false, nil ])
      
      validates_presence_of :name, :price
      validates_numericality_of :price


    end
  end
end

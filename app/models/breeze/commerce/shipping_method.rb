module Breeze
  module Commerce
    class ShippingMethod
      include Mongoid::Document

      belongs_to :store, :class_name => "Breeze::Commerce::Store", :inverse_of => :shipping_methods
      has_many :orders, :class_name => "Breeze::Commerce::Order", :inverse_of => :shipping_methods

      field :name
      field :description
      field :price, :type => Integer
      field :archived, type: Boolean, default: false
      field :is_default, type: Boolean, default: false

      scope :archived, where(:archived => true)
      scope :unarchived, where(:archived.in => [ false, nil ])
      
      validates_presence_of :name, :price
      validates_numericality_of :price

      def is_default?
        is_default
      end


    end
  end
end

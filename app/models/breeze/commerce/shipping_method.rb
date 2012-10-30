module Breeze
  module Commerce
    class ShippingMethod
      include Mongoid::Document

      attr_accessible :name, :description, :price, :price_cents, :is_default, :archived, :position, :store

      belongs_to :store, :class_name => "Breeze::Commerce::Store", :inverse_of => :shipping_methods
      has_many :orders, :class_name => "Breeze::Commerce::Order", :inverse_of => :shipping_methods

      field :name
      field :description
      field :price_cents, :type => Integer
      field :archived, type: Boolean, default: false
      field :position, :type => Integer

      default_scope order_by([:position, :asc])
      scope :archived, where(:archived => true)
      scope :unarchived, where(:archived.in => [ false, nil ])
      
      validates_presence_of :store, :name, :price_cents
      validates_numericality_of :price_cents
      validates_uniqueness_of :name

      after_save :set_as_default

      # Return an array containing this class and all subclasses
      def self.types
        self.descendants.unshift self
      end

      def price(order=nil)
        self.price_cents.to_i / 100.0
        # ForeignDecoratorShipping(self)
      end

      def price=(price)
        self.price_cents = (price.to_f  * 100).round
      end

      def price_explanation
        "Flat shipping rate of $#{price} for all orders"
      end

      private

      # If this is the only shipping method, it should be set as the default shipping method for the store
      def set_as_default
        unless store.default_shipping_method
          store.default_shipping_method = self
          store.save
        end
      end
      
    end
  end
end

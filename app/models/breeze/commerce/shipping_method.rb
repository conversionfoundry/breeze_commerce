module Breeze
  module Commerce
    class ShippingMethod
      include Mongoid::Document
      include ::Breeze::Commerce::Mixins::Archivable

      attr_accessible :name, :description, :price, :price_cents, :is_default, :position, :store

      has_many :orders, :class_name => "Breeze::Commerce::Order", :inverse_of => :shipping_methods

      field :name
      field :description
      field :price_cents, :type => Integer
      field :position, :type => Integer

      default_scope order_by([:position, :asc])
      
      validates_presence_of :name, :price_cents
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
        store = Breeze::Commerce::Store.first
        unless store.default_shipping_method
          store.default_shipping_method = self
          store.save
        end
      end
      
    end
  end
end

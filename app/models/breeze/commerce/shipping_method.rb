module Breeze
  module Commerce
    class ShippingMethod
      include Mongoid::Document

      belongs_to :store, :class_name => "Breeze::Commerce::Store", :inverse_of => :shipping_methods
      has_many :orders, :class_name => "Breeze::Commerce::Order", :inverse_of => :shipping_methods

      field :name
      field :description
      field :price_cents, :type => Integer
      field :archived, type: Boolean, default: false
      field :is_default, type: Boolean, default: false

      scope :archived, where(:archived => true)
      scope :unarchived, where(:archived.in => [ false, nil ])
      
      validates_presence_of :name, :price_cents
      validates_numericality_of :price_cents
      validates_uniqueness_of :name

      before_save :set_default_if_only
      before_destroy :set_a_new_default

      def self.default
        Breeze::Commerce::ShippingMethod.where(is_default: true).first
      end

      def is_default?
        is_default
      end

      def price
        (self.price_cents || 0) / 100.0
      end

      def price=(price)
        self.price_cents = (price.to_f  * 100).to_i
      end

      private

      # If this is the only shipping method, it should be set as the default, so that new orders can show a shipping estimate
      def set_default_if_only
        if Breeze::Commerce::ShippingMethod.unarchived.count == 0
          write_attribute(:is_default, true)
        end
      end

      def set_a_new_default
        if Breeze::Commerce::ShippingMethod.unarchived.count == 0
          write_attribute(:is_default, true)
        end
      end
      
    end
  end
end

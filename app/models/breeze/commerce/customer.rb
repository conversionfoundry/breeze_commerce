module Breeze
  module Commerce
    class Customer < Breeze::Account::Customer
      include Mixins::Archivable

      attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :shipping_address_attributes, :billing_address_attributes

      has_many :orders, :class_name => 'Breeze::Commerce::Order'
      embeds_one :shipping_address, :class_name => 'Breeze::Commerce::Address'
      embeds_one :billing_address, :class_name => 'Breeze::Commerce::Address'

      accepts_nested_attributes_for :billing_address
      accepts_nested_attributes_for :shipping_address

      validates_uniqueness_of :email
      
      def last_order
        orders.last
      end

      def order_total
        orders.map{|o| o.total}.sum
      end
      
      def editor?
        false
      end

    end
  end
end

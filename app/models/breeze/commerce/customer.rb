module Breeze
  module Commerce
    class Customer < Breeze::Account::Customer
      include Mixins::Archivable

      FILTERS = [
        {:scope => "all",         :label => "All Customers"},
        {:scope => "with_orders", :label => "Customers who've made orders"},
        {:scope => "without_orders", :label => "Customers who've made no orders"}
      ]

      attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :shipping_address_attributes, :billing_address_attributes

      has_many :orders, :class_name => 'Breeze::Commerce::Order'
      embeds_one :shipping_address, :class_name => 'Breeze::Commerce::Address'
      embeds_one :billing_address, :class_name => 'Breeze::Commerce::Address'

      accepts_nested_attributes_for :billing_address
      accepts_nested_attributes_for :shipping_address

      scope :with_orders, -> { any_in(:_id => includes(:orders).select{ |customer| customer.orders.size > 0 }.map{ |r| r.id }) }
      scope :without_orders, -> { any_in(:_id => includes(:orders).select{ |customer| customer.orders.size == 0 }.map{ |r| r.id }) }

      validates_presence_of :email
      validates_uniqueness_of :email

      def self.new_with_information(order, password)
        new(
          first_name: order.billing_address.name.split(' ').first,
          last_name: order.billing_address.name.split(' ').last,
          email: order.email,
          password: password,
          password_confirmation: password,
          shipping_address: Breeze::Commerce::Address.new(order.shipping_address.attributes),
          billing_address: Breeze::Commerce::Address.new(order.billing_address.attributes),
          store: Breeze::Commerce::Store.first
        )
      end


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

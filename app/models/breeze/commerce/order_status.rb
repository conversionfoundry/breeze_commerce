module Breeze
  module Commerce
    class OrderStatus
      include Mongoid::Document
      
      # Built-in billing statuses: :new, :payment_in_process, :payment_received, :partial_payment_received, :payment_declined, :cancelled_by_customer, :cancelled_by_merchant, :disputed
      # Built-in shipping statuses: :new, :processing, :delivered, :will_not_deliver

      attr_accessible :name, :description, :type, :sort_order
      field :name
      field :description
      field :type # :billing or :shipping
      field :sort_order, type: Integer
      
      belongs_to :store, :class_name => "Breeze::Commerce::Store", :inverse_of => :order_statuses
      has_many :orders, :class_name => "Breeze::Commerce::Order", :inverse_of => :order_statuses
      
      validates_presence_of :name

      # Default billing status for new orders
      def self.billing_default(store)
        Breeze::Commerce::OrderStatus.where(:store => store, :type => :billing, :name => 'Browsing').first
      end

      # Default shipping status for new orders
      def self.shipping_default(store)
        Breeze::Commerce::OrderStatus.where(:store => store, :type => :shipping, :name => 'Not Shipped Yet').first
      end

    end
  end
end

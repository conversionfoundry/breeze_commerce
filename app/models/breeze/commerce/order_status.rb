module Breeze
  module Commerce
    class OrderStatus
      include Mongoid::Document
      
      # Built-in billing statuses: :new, :payment_in_process, :payment_received, :partial_payment_received, :payment_declined, :cancelled_by_customer, :cancelled_by_merchant, :disputed
      # Built-in shipping statuses: :new, :processing, :delivered, :will_not_deliver

      field :name
      field :description
      field :type # :billing or :shipping
      field :sort_order, type: Integer
      
      belongs_to :store, :class_name => "Breeze::Commerce::Store", :inverse_of => :order_statuses
      has_many :orders, :class_name => "Breeze::Commerce::Order", :inverse_of => :order_statuses
      
      validates_presence_of :name

    end
  end
end

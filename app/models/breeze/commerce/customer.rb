module Breeze
  module Commerce
    class Customer < Breeze::Account::Customer

      attr_accessible :archived

      has_many :orders, :class_name => 'Breeze::Commerce::Order'
      embeds_one :shipping_address, :class_name => 'Breeze::Commerce::Address'
      embeds_one :billing_address, :class_name => 'Breeze::Commerce::Address'

      accepts_nested_attributes_for :billing_address
      accepts_nested_attributes_for :shipping_address

      field :archived, type: Boolean, default: false

      scope :archived, where(:archived => true)
      scope :unarchived, where(:archived.in => [ false, nil ])

      validates_uniqueness_of :email
      
      def last_order
        orders.last
      end

      def order_total
        orders.map{|o| o.total}.sum
      end
      
    end
  end
end

module Breeze
  module Commerce
    class Order
      include Mongoid::Document
      include Mongoid::Timestamps
      
      field :email
      field :subscribe, :type => Boolean
      field :personal_message
      field :comment
      field :payment_completed

      field :archived, type: Boolean, default: false

      scope :archived, where(:archived => true)
      scope :unarchived, where(:archived.in => [ false, nil ])

      belongs_to :store, :class_name => "Breeze::Commerce::Store", :inverse_of => :orders
      belongs_to :customer, :class_name => "Breeze::Commerce::Customer", :inverse_of => :orders
      belongs_to :billing_status, :class_name => "Breeze::Commerce::OrderStatus", :inverse_of => :orders
      belongs_to :shipping_status, :class_name => "Breeze::Commerce::OrderStatus", :inverse_of => :orders
      has_many :line_items, :class_name => "Breeze::Commerce::LineItem"
      embeds_one :shipping_address, :class_name => "Breeze::Commerce::Address"
      embeds_one :billing_address, :class_name => "Breeze::Commerce::Address"
      embeds_many :notes, :class_name => "Breeze::Commerce::Note"

      # TODO: I'm not sure why local_foreign_key was used here. It seems not to work.
      # references_one :shipping_method, :class_name => "Breeze::Commerce::ShippingMethod", :local_foreign_key => true
      # references_one :shipping_method, :class_name => "Breeze::Commerce::ShippingMethod"
      belongs_to_related :shipping_method, :class_name => "Breeze::Commerce::ShippingMethod", :inverse_of => :orders

      # Don't validate customer - this might be a new order created for a browsing customer, or the order might be for an anonymous guest
      # validates_presence_of :customer

      # Order numbers are strings in the format "2012-07-12-60319"
      # The last section is seconds since midnight on the order date, zero-padded to always be five digits
      def order_number
        if created_at
          created_at.to_date.to_s + '-' + sprintf('%05d', created_at.seconds_since_midnight.to_i)
        else
          'XXXX-XX-XX-XXXXX'
        end
      end

      # In principle, there could be more than one payment associated with an order. FOr example, there might be a failed payment then a successful one.
      def payments
        Breeze::Commerce::Payment.where(:reference => id)
      end

      def payment_completed?
        payment_completed
      end

      def name
        billing_address.name || "unknown"
      end

      def item_total
        line_items.map(&:amount).sum
      end

      def item_count
        line_items.map(&:quantity).sum
      end

      # def shipping_method
      #   shipping_method || Breeze::Commerce::Store.first.shipping_methods.first
      # end

      def shipping_total
        if shipping_method
          shipping_method.price  # TODO: calculate shipping
        else
          0
        end
      end

      def total
        item_total + shipping_total
      end

      def to_s
        '$' + total.to_s + ' ' + created_at.to_s
      end
    end
  end
end

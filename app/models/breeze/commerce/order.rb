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
      has_many :line_items, :class_name => "Breeze::Commerce::LineItem" # Ideally, this would be embedded, but we couldn't reference variant from an embedded line item
      embeds_one :shipping_address, :class_name => "Breeze::Commerce::Address"
      embeds_one :billing_address, :class_name => "Breeze::Commerce::Address"
      embeds_many :notes, :class_name => "Breeze::Commerce::Note"
      belongs_to_related :shipping_method, :class_name => "Breeze::Commerce::ShippingMethod", :inverse_of => :orders

      accepts_nested_attributes_for :line_items, :reject_if => lambda { |l| l[:variant_id].blank? }

      # Don't validate customer - this might be a new order created for a browsing customer, or the order might be for an anonymous guest
      # validates_presence_of :customer

      before_validation :set_initial_order_statuses

      validates_presence_of :billing_status, :shipping_status

      def set_initial_order_statuses
        # TODO: Handle case where install generator hasn't been run yet, so these default statuses don't exist
        self.billing_status = Breeze::Commerce::OrderStatus.where(:type => :billing, :name => 'Browsing').first unless billing_status
        self.shipping_status = Breeze::Commerce::OrderStatus.where(:type => :shipping, :name => 'Not Shipped Yet').first unless shipping_status
        self.shipping_method = Breeze::Commerce::Store.first.shipping_methods.where(:is_default => true).first unless shipping_method
      end

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
        if billing_address && billing_address.name
          billing_address.name
        else
          "unknown"
        end
      end

      def item_total
        line_items.unarchived.map(&:amount).sum
      end

      def item_count
        line_items.unarchived.map(&:quantity).sum
      end

      # def shipping_method
      #   shipping_method || Breeze::Commerce::Store.first.shipping_methods.first
      # end

      # def shipping_method
      #   read_attribute(:shipping_method)
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

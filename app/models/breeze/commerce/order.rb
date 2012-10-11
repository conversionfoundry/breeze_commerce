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
      
      belongs_to :store, :class_name => "Breeze::Commerce::Store", :inverse_of => :orders
      belongs_to :customer, :class_name => "Breeze::Commerce::Customer", :inverse_of => :orders
      belongs_to :billing_status, :class_name => "Breeze::Commerce::OrderStatus", :inverse_of => :orders
      belongs_to :shipping_status, :class_name => "Breeze::Commerce::OrderStatus", :inverse_of => :orders
      has_many :line_items, :class_name => "Breeze::Commerce::LineItem" # Ideally, this would be embedded, but then we couldn't reference variant from an embedded line item
      embeds_one :shipping_address, :class_name => "Breeze::Commerce::Address"
      embeds_one :billing_address, :class_name => "Breeze::Commerce::Address"
      embeds_many :notes, :class_name => "Breeze::Commerce::Note"
      belongs_to :shipping_method, :class_name => "Breeze::Commerce::ShippingMethod", :inverse_of => :orders

      accepts_nested_attributes_for :line_items, :reject_if => lambda { |l| l[:variant_id].blank? }

      scope :archived, where(:archived => true)
      scope :unarchived, where(:archived.in => [ false, nil ])
      scope :not_browsing, lambda { conditions( [ "billing_status_id != " + Breeze::Commerce::OrderStatus.where(name: 'Browsing').first.id.to_s ] ) }

      # Don't validate customer - this might be a new order created for a browsing customer, or the order might be for an anonymous guest
      # validates_presence_of :customer

      before_validation :set_initial_order_statuses
      validates_presence_of :store, :billing_status, :shipping_status


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

      def item_total_cents
        line_items.unarchived.map(&:amount_cents).sum
      end

      def item_count
        line_items.unarchived.map(&:quantity).sum
      end

      def shipping_total
        if shipping_method && line_items.count > 0
          shipping_method.price(self)
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

      def show_in_admin?
        if billing_status.name == 'Browsing'
          return false
        end
        true
      end

      protected

      def set_initial_order_statuses 
          # self.billing_status ||= Breeze::Commerce::OrderStatus.where(:store => store, :type => :billing, :name => 'Browsing').first
          # binding.pry
          self.billing_status ||= Breeze::Commerce::OrderStatus.billing_default(store)
          self.shipping_status ||= Breeze::Commerce::OrderStatus.shipping_default(store)
          self.shipping_method ||= Breeze::Commerce::ShippingMethod.where(:store => store, :is_default => true).first
        
        # end
      end

    end
  end
end

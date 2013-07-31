module Breeze
  module Commerce
    class Order
      include Mongoid::Document
      include Mongoid::Timestamps
      include Mixins::Archivable

      FILTERS = [
        {:scope => "all",         :label => "All Orders"},
        {:scope => "unfulfilled", :label => "Unfulfilled Orders"},
        {:scope => "fulfilled",   :label => "Fulfilled Orders"},
      ]

      attr_accessible :email, :personal_message, :comment, :shipping_address, :shipping_address_id, :billing_address, :billing_address_id, :shipping_method, :shipping_status_id, :billing_status_id, :customer_id, :shipping_method_id, :serialized_coupon, :coupon, :country_id
      field :email
      field :personal_message
      field :comment
      field :payment_completed
      field :serialized_coupon, type: Hash

      belongs_to :customer, class_name: "Breeze::Commerce::Customer", :inverse_of => :orders
      belongs_to :billing_status, class_name: "Breeze::Commerce::OrderStatus", :inverse_of => :orders
      belongs_to :shipping_status, class_name: "Breeze::Commerce::OrderStatus", :inverse_of => :orders
      has_many :line_items, class_name: "Breeze::Commerce::LineItem" # Ideally, this would be embedded, but then we couldn't reference variant from an embedded line item
      embeds_one :shipping_address, class_name: "Breeze::Commerce::Address"
      embeds_one :billing_address, class_name: "Breeze::Commerce::Address"
      embeds_many :notes, class_name: "Breeze::Commerce::Note"
      belongs_to :shipping_method, class_name: "Breeze::Commerce::Shipping::ShippingMethod", :inverse_of => :orders
      belongs_to :country, class_name: "Breeze::Commerce::Shipping::Country"

      accepts_nested_attributes_for :line_items, :reject_if => lambda { |l| l[:variant_id].blank? }

      scope :not_browsing, -> { ne( billing_status: Breeze::Commerce::Store.first.initial_billing_status ) }
      scope :unfulfilled, -> { where( billing_status: Breeze::Commerce::Store.first.payment_confirmed_billing_status, shipping_status: Breeze::Commerce::Store.first.initial_shipping_status ) }
      scope :fulfilled, -> { where( billing_status: Breeze::Commerce::Store.first.payment_confirmed_billing_status, shipping_status: Breeze::Commerce::Store.first.shipped_shipping_status ) }
      scope :actionable, -> { nin( billing_status: [ Breeze::Commerce::Store.first.initial_billing_status, Breeze::Commerce::Store.first.checkout_billing_status ] ) }
      scope :abandoned, -> { where(billing_status: Breeze::Commerce::Store.first.initial_billing_status, created_at: {'$lt' => 2.weeks.ago}) }

      # Don't validate customer - this might be a new order created for a browsing customer, or the order might be for an anonymous guest
      # validates_presence_of :customer

      before_validation :set_initial_state, :update_shipping_method
      validates_presence_of :billing_status, :shipping_status

      def confirm_payment(payment)
        # txnId = payment.pxpay_response[:txn_id]
        unless payment.succeeded # A payment can only be successful once.
          payment.update_attribute(:succeeded, true)
          self.payment_completed = true
          self.billing_status = Breeze::Commerce::Store.first.payment_confirmed_billing_status
          self.save

          deliver_confirmation_emails
        end
      end

      def deliver_confirmation_emails
        Breeze::Commerce::OrderMailer.new_order_merchant_notification(self).deliver if Breeze::Admin::User.all.select{|user| user.roles.include? :merchant}.any?
        Breeze::Commerce::OrderMailer.new_order_customer_notification(self).deliver
      end

      # Order numbers are strings in the format "2012-07-12-60319"
      # The last section is seconds since midnight on the order date, zero-padded to always be five digits
      def order_number
        if created_at
          # ssm = created_at.seconds_since_midnight.to_i
          # created_at.to_date.to_s + '-' + sprintf( '%05d', (ssm + rand(100000)).modulo(100000) )
          created_at.to_date.to_s + '-' + sprintf('%05d', created_at.seconds_since_midnight.to_i)
        else
          'XXXX-XX-XX-XXXXX'
        end
      end

      # There could be more than one payment associated with an order. For example, there might be a failed payment then a successful one.
      def payments
        Breeze::Commerce::Payment.where(:reference => id)
      end

      def payment_completed?
        payment_completed
      end

      def transaction_completed_at
        if self.payments.any?
          self.payments.last.updated_at || nil
        else
          nil
        end
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

      def coupon_total_cents
        if self.coupon
          discount = coupon.discount_cents(self)
        else
          0
        end
      end

      def coupon_total
        if self.coupon
          discount = coupon.discount(self)
        else
          0
        end
      end

      def total
        [ (item_total - coupon_total), 0].max + shipping_total
      end

      def to_s
        '$' + total.to_s + store.currency + ' ' + created_at.to_s
      end

      def has_item_with_tag?(tag)
        line_items.each do |line_item|
          if line_item.product.tags.include? tag
            return true
          end
        end
        false
      end

      def can_resend?
        if customer == nil
          return false
        end
        line_items.each do |line_item|
          if Breeze::Commerce::Variant.unarchived.where(id: line_item.variant_id).count == 0
            return false
          end
        end
        true
      end

      def duplicate_for_resend
        if can_resend?
          new_order = Breeze::Commerce::Order.new customer_id: customer.id
          line_items.each do |line_item|
            new_order.line_items << line_item.dup
          end
          new_order.save
          new_order
        else
          false
        end
      end

      def serialize_coupon coupon
        self.update_attribute(:serialized_coupon, coupon.attributes.dup)
      end

      def coupon
        if serialized_coupon
          Breeze::Commerce::Coupons::Coupon.new serialized_coupon
        else
          nil
        end
      end

      protected

      # If the country changes, we may need to also change the shipping method
      def update_shipping_method
        if country
          unless country.shipping_methods.include? shipping_method
            self.shipping_method = self.country.shipping_methods.unarchived.first
          end
        end
      end

      def set_initial_state
        store = Breeze::Commerce::Store.first
        self.billing_status ||= store.initial_billing_status
        self.shipping_status ||= store.initial_shipping_status
        self.country ||= store.default_country
        self.shipping_method ||= store.default_shipping_method
      end

    end
  end
end

module Breeze
  module Commerce
    class Coupon
      include Mongoid::Document
      identity :type => String

      TYPES = { 1 => "Fixed Amount", 2 => "% of Order Value", 3 => "Free Shipping" }

      belongs_to_related :store, :class_name => "Breeze::Commerce::Store", :inverse_of => :coupons

      field :name
      field :code
      field :type, :type => Integer, :default => 1
      field :fixed_amount_cents, :type => Integer
      field :percentage, :type => Float
      field :minimum_order_value_cents, :type => Integer
      field :start, :type => Time
      field :end, :type => Time
      field :active, :type => Boolean, :default => false

      validates_presence_of :name

      after_initialize :generate_code

      attr_accessor :now, :never

      scope :drafts, where(:active.ne => true)
      scope :published, where(:active => true)
      scope :expired, where(:active => true)

      def to_s
        name
      end

      def days_remaining
        return "" if self.end.nil?
        6
      end

      private

      def generate_code
        # srand booking.id
        self.code = Digest::MD5.hexdigest(rand.to_s + Time.now.to_s)[1..8]
        self.now = true
        self.never = true
      end
    end
  end
end

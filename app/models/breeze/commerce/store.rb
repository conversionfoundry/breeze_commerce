module Breeze
  module Commerce
    class Store
      include Mongoid::Document
      
      has_many :categories, :class_name => "Breeze::Commerce::Category"
      has_many :products, :class_name => "Breeze::Commerce::Product"
      # has_many :coupons, :class_name => "Breeze::Commerce::Coupon"
      has_many :customers, :class_name => "Breeze::Commerce::Customer"
      has_many :orders, :class_name => "Breeze::Commerce::Order"
      has_many :order_statuses, :class_name => "Breeze::Commerce::OrderStatus"
      has_many :shipping_methods, :class_name => "Breeze::Commerce::ShippingMethod"

      belongs_to :home_page, :class_name => "Breeze::Content::Page"

      def home_page
        read_attribute(:home_page) || Breeze::Content::Page.root.first
      end
      
    end
  end
end

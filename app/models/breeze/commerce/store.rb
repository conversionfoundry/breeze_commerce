module Breeze
  module Commerce
    class Store #< Breeze::Content::Page
      include Mongoid::Document
      identity :type => String
      
      has_many_related :categories, :class_name => "Breeze::Commerce::Category"
      has_many_related :products, :class_name => "Breeze::Commerce::Product"
      has_many_related :coupons, :class_name => "Breeze::Commerce::Coupon"
      has_many :customers, :class_name => "Breeze::Commerce::Customer"
      has_many :orders, :class_name => "Breeze::Commerce::Order"
      has_many :order_statuses, :class_name => "Breeze::Commerce::OrderStatus"
      has_many_related :shipping_methods, :class_name => "Breeze::Commerce::ShippingMethod"

      belongs_to :home_page, :class_name => "Breeze::Content::Page"
      
    end
  end
end

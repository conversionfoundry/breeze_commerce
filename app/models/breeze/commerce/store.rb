module Breeze
  module Commerce
    class Store
      include Mongoid::Document

      field :allow_returning_customer_login, :type => Boolean

      has_many :categories, :class_name => "Breeze::Commerce::Category"
      has_many :products, :class_name => "Breeze::Commerce::Product"
      has_many :customers, :class_name => "Breeze::Commerce::Customer"
      has_many :orders, :class_name => "Breeze::Commerce::Order"
      has_many :order_statuses, :class_name => "Breeze::Commerce::OrderStatus"
      has_many :shipping_methods, :class_name => "Breeze::Commerce::ShippingMethod"

      belongs_to :home_page, :class_name => "Breeze::Content::Page"

      # after_create :set_up_order_statuses

      # def self.create
      #   Breeze::Commerce::Store.transaction do
      #     super(*args)
      #     set_up_order_statuses
      #   end
      # end

      # def home_page
      #   read_attribute(:home_page) || Breeze::Content::Page.root.first
      # end

      # Set up built-in order statuses
      # In future we may provide the option to create custom order statuses for stores, but we need some standard built-in ones to work with.
      # TODO: SHould this be in db/seeds?
      def set_up_order_statuses
          # Generate built-in order statuses for billing
          unless order_statuses.where(:type => :billing, :name => "Browsing").count > 0
            order_statuses.create(:type => :billing, :name => "Browsing", :sort_order => 0,:description => "Customer has added items to his or her cart, but hasn't gone to checkout yet")
          end
          unless order_statuses.where(:type => :billing, :name => "Started Checkout").count > 0
            order_statuses.create(:type => :billing, :name => "Started Checkout", :sort_order => 1, :description => "Customer has taken this order to checkout")
          end
          unless order_statuses.where(:type => :billing, :name => "Payment in process").count > 0
            order_statuses.create(:type => :billing, :name => "Payment in process", :sort_order => 2, :description => "Customer has clicked Pay Now, and the order is currently with the payment processor")
          end
          unless order_statuses.where(:type => :billing, :name => "Payment Received").count > 0
            order_statuses.create(:type => :billing, :name => "Payment Received", :sort_order => 3, :description => "Order has been paid in full")
          end
          unless order_statuses.where(:type => :billing, :name => "Partial Payment Received").count > 0
            order_statuses.create(:type => :billing, :name => "Partial Payment Received", :sort_order => 4, :description => "Some payment has been received, but not full")
          end
          unless order_statuses.where(:type => :billing, :name => "Cancelled by Customer").count > 0
            order_statuses.create(:type => :billing, :name => "Cancelled by Customer", :sort_order => 5, :description => "Customer cancelled order")
          end
          unless order_statuses.where(:type => :billing, :name => "Cancelled by Merchant").count > 0
            order_statuses.create(:type => :billing, :name => "Cancelled by Merchant", :sort_order => 6, :description => "Merchant cancelled order")
          end
          unless order_statuses.where(:type => :billing, :name => "Disputed").count > 0
            order_statuses.create(:type => :billing, :name => "Disputed", :sort_order => 7, :description => "Something's gone wrong")
          end

          # Generate built-in order statuses for billing
          unless order_statuses.where(:type => :shipping, :name => "Not Shipped Yet").count > 0
            order_statuses.create(:type => :shipping, :name => "Not Shipped Yet", :sort_order => 0, :description => "Newly-created order")
          end
          unless order_statuses.where(:type => :shipping, :name => "Processing").count > 0
            order_statuses.create(:type => :shipping, :name => "Processing", :sort_order => 1, :description => "Getting ready to ship")
          end
          unless order_statuses.where(:type => :shipping, :name => "Shipped").count > 0
            order_statuses.create(:type => :shipping, :name => "Shipped", :sort_order => 2, :description => "Order has been shipped")
          end
          unless order_statuses.where(:type => :shipping, :name => "Will Not Ship").count > 0
            order_statuses.create(:type => :shipping, :name => "Will Not Ship", :sort_order => 3, :description => "Shipping has been cancelled")
          end

      end
      
    end
  end
end

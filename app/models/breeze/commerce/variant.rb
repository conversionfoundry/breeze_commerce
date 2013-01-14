# require 'app/uploaders/pic'
require 'carrierwave/mongoid'

module Breeze
  module Commerce

    # Variants should not be valid unless they have an option for each proprty of their parent product.
    class AllOptionsFilledValidator < ActiveModel::Validator
      def validate(variant)
        if variant.product
          variant.product.properties.each do |property|
            variant.errors[:base] << "Must have a value for " + property.name unless variant.option_for_property(property)
          end
        end
      end
    end

    class Variant
      include Mongoid::Document
      include Mixins::Archivable
      include Mixins::Publishable

      attr_accessible :product, :product_id, :blurb, :cost_price_cents, :discounted, :discounted_sell_price_cents, :image, :name, :sell_price_cents, :sku_code, :cost_price, :sell_price, :discounted_sell_price, :position

      belongs_to :product, :class_name => "Breeze::Commerce::Product"
      has_and_belongs_to_many :options, :class_name => "Breeze::Commerce::Option"
      has_many :line_items, :class_name => "Breeze::Commerce::LineItem"
      
      index({ product_id: 1 })

      field :blurb
      field :cost_price_cents, :type => Integer
      field :discounted, type: Boolean
      field :discounted_sell_price_cents, :type => Integer
      field :image
      field :name
      field :sell_price_cents, :type => Integer
      field :sku_code
      field :position, :type => Integer

      mount_uploader :image, Breeze::Commerce::VariantImageUploader

      scope :with_option, lambda { |option| where(option_ids: option.id) }
      scope :discounted, where(discounted: true)
      scope :not_discounted, where(:discounted.in => [false, nil])
      scope :ordered, order_by(:position.asc)

      before_validation :set_initial_position, :set_standard_sku_code

      validates_presence_of :product_id, :name, :sku_code, :sell_price_cents
      validates_uniqueness_of :sku_code
      validates_with AllOptionsFilledValidator

      # If there's no variant image, try to find an image for the parent product
      def image
        if read_attribute(:image) 
          read_attribute(:image) 
        elsif product && product.images.first
          product.images.first.file
        else
          nil
        end
      end

      def cost_price
        (self.cost_price_cents || 0) / 100.0
      end

      def cost_price=(price)
        self.cost_price_cents = (price.to_f  * 100).round
      end

      def sell_price
        (self.sell_price_cents || 0) / 100.0
      end

      def sell_price=(price)
        self.sell_price_cents = (price.to_f  * 100).round
      end

      def discounted_sell_price
        (self.discounted_sell_price_cents || 0) / 100.0
      end

      def discounted_sell_price=(price)
        self.discounted_sell_price_cents = (price.to_f  * 100).round
      end
      
      # Show the most relevant price
      # This is used to calculate order totals. For display in views, it's better to display the sell price crossed out followed by the discounted price, if any.
      def display_price
        self.discounted ? self.discounted_sell_price : self.sell_price
      end
      
      def display_price_cents
        self.discounted ? self.discounted_sell_price_cents : self.sell_price_cents
      end

      # Return the option this variant has for a given property
      # e.g. For variant "red pants", given the property "colour", return the option "red"
      def option_for_property(property)
        self.options.select{|o| o.property == property}.first || nil
      end

      def number_of_sales
        count = 0
        line_items.unarchived.each do | line_item|
          if line_item.order && line_item.order.payment_completed?  # Line Item should always have an order, but occasionally the dev data gets screwed up
            count += line_item.quantity
          end
        end
        count
      end

      def set_initial_position
        self.position = product.variants.count if product
      end

      def set_standard_sku_code
        if sku_code.blank?
          name = product.name 
          if options.any?
            name = name + " " + options.map{ |option| option.name}.join(" ")
          end
          self.sku_code = name.downcase.gsub(" ", "_")
        end
      end

    end
    
    
  end
end

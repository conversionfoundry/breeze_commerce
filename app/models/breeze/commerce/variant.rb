# require 'app/uploaders/pic'
require 'carrierwave/mongoid'

module Breeze
  module Commerce

    # Variants should not be valid unless they have an option for each proprty of their parent product.
    class AllOptionsFilledValidator < ActiveModel::Validator
      def validate(variant)
        variant.product.properties.each do |property|
          variant.errors[:base] << "Must have a value for " + property.name unless variant.option_for_property(property)
        end
      end
    end

    class Variant
      include Mongoid::Document

      belongs_to :product, :class_name => "Breeze::Commerce::Product"
      has_and_belongs_to_many :options, :class_name => "Breeze::Commerce::Option"
      has_one :image, :class_name => "Breeze::Commerce::VariantImage"
      has_many :line_items, :class_name => "Breeze::Commerce::LineItem"
      
      field :image
      mount_uploader :image, Breeze::Commerce::VariantImageUploader

      field :name
      field :sku_code
      # field :price_offset_cents, :type => Integer
      field :available, :type => Boolean
      field :blurb

      field :cost_price_cents, :type => Integer
      field :sell_price_cents, :type => Integer
      field :discounted_sell_price_cents, :type => Integer

      # field :folder
      # field :image_width, :type => Integer
      # field :image_height, :type => Integer

      field :archived, type: Boolean, default: false

      scope :archived, where(:archived => true)
      scope :unarchived, where(:archived.in => [ false, nil ])

      validates_presence_of :name, :sku_code, :cost_price, :sell_price
      validates_uniqueness_of :sku_code
      validates_with AllOptionsFilledValidator

      # def price_offset
      #   (self.price_offset_cents || 0) / 100.0
      # end

      # def price_offset=(offset)
      #   self.price_offset_cents = offset.to_i * 100
      # end

      # def price
      #   product.sell_price
      # end
      
      # def display_price
      #   (self.price || 0) / 100.0
      # end

      def cost_price
        (self.cost_price_cents || 0) / 100.0
      end

      def cost_price=(price)
        self.cost_price_cents = price.to_i * 100
      end

      def sell_price
        (self.sell_price_cents || 0) / 100.0
      end

      def sell_price=(price)
        self.sell_price_cents = price.to_i * 100
      end

      def discounted_sell_price
        (self.discounted_sell_price_cents || 0) / 100.0
      end

      def discounted_sell_price=(price)
        self.discounted_sell_price_cents = price.to_i * 100
      end
      
      def display_price
        self.discounted_sell_price > 0 ? self.discounted_sell_price : self.sell_price
      end
      
      
      def option_for_property(property)
        self.options.select{|o| o.property == property}.first || nil
      end
      
    end
    
    
  end
end

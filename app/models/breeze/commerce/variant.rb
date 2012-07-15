module Breeze
  module Commerce

    # Variants should not be valid unless they have an option for each proprty of their parent product.
    class AllOptionsFilledValidator < ActiveModel::Validator
      def validate(variant)
        variant.product.properties.each do |property|
          # binding.pry
          # Rails.logger.debug '*************'
          # Rails.logger.debug variant.errors
          # Rails.logger.debug variant.option_for_property(property).class.to_s
          variant.errors[:base] << "Must have a value for " + property.name unless variant.option_for_property(property)
        end
      end
    end

    class Variant
      include Mongoid::Document
      identity :type => String

      belongs_to :product, :class_name => "Breeze::Commerce::Product"
      has_and_belongs_to_many :options, :class_name => "Breeze::Commerce::Option"
      
      #embedded_in :product, :class_name => "Breeze::Commerce::Variant", :inverse_of => :variants
      #
      referenced_in :line_item
      
      
      mount_uploader :image, Breeze::Commerce::VariantUploader, :mount_on => :file

      field :name
      field :sku_code
      field :price_offset_cents, :type => Integer
      field :available, :type => Boolean

      field :folder
      field :image_width, :type => Integer
      field :image_height, :type => Integer

      validates_presence_of :name, :sku_code
      validates_with AllOptionsFilledValidator

      def price_offset
        (self.price_offset_cents || 0) / 100.0
      end

      def price_offset=(offset)
        self.price_offset_cents = offset.to_i * 100
      end

      def price
        product.sell_price
      end
      
      def display_price
        (self.price || 0) / 100.0
      end
      
      def option_for_property(property)
        self.options.select{|o| o.property == property}.first || nil
      end
      
    end
    
    
  end
end

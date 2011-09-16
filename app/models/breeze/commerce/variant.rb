module Breeze
  module Commerce
    class Variant
      include Mongoid::Document

      belongs_to_related :product, :class_name => "Breeze::Commerce::Product"
      #embedded_in :product, :class_name => "Breeze::Commerce::Variant", :inverse_of => :variants
      #
      
      mount_uploader :image, Breeze::Commerce::VariantUploader, :mount_on => :file

      field :name
      field :sku_code
      field :price_offset_cents, :type => Integer
      field :available, :type => Boolean

      field :folder
      field :image_width, :type => Integer
      field :image_height, :type => Integer

      validates_presence_of :name, :sku_code

      def price_offset
        (self.price_offset_cents || 0) / 100.0
      end

      def price_offset=(offset)
        self.price_offset_cents = offset.to_i * 100
      end

      def price
        product.sell_price
      end
    end
  end
end

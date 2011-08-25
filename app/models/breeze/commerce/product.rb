module Breeze
  module Commerce
    class Product
      include Mongoid::Document
      include Mongoid::Timestamps

      include Breeze::Content::Mixins::Permalinks

      identity :type => String

      has_many_related :categories, :class_name => "Breeze::Commerce::Category", :stored_as => :array
      embeds_many :variants, :class_name => "Breeze::Commerce::Variant"
      embeds_many :images, :class_name => "Breeze::Commerce::ProductImage"

      field :name
      field :teaser
      field :short_description
      field :full_description
      field :available_stock, :type => Integer
      field :cost_price_cents, :type => Integer
      field :sell_price_cents, :type => Integer
      field :discounted_sell_price_cents, :type => Integer
      field :content, :markdown => true
      field :available, :type => Boolean

      field :weight
      field :height
      field :width
      field :depth
        
      # referenced_in :line_item

      validates_presence_of :name, :slug

      def icon_image
        "thumbnails/icon/products/wigs1.jpg" 
      end

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
    end
  end
end

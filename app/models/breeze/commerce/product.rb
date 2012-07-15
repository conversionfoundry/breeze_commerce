module Breeze
  module Commerce

    #TODO: validates_associated doesn't seem to work here, so I've stuck in this ugly custom validator
    class AllVariantsValidValidator < ActiveModel::Validator
      def validate(product)
        product.variants.each do |variant|
          # binding.pry
          # Rails.logger.debug '*************'
          # Rails.logger.debug variant.errors
          # Rails.logger.debug variant.option_for_property(property).class.to_s
          unless variant.valid?
            product.errors[:base] << "Variant " + variant.name + " is missing a value."
          end
        end
      end
    end

    class Product < Breeze::Content::Page
      
      identity :type => String

      belongs_to_related :store, :class_name => "Breeze::Commerce::Store", :inverse_of => :products
      has_and_belongs_to_many :categories, :class_name => "Breeze::Commerce::Category"

      has_and_belongs_to_many :properties, :class_name => "Breeze::Commerce::Property"
      has_many :variants, :class_name => "Breeze::Commerce::Variant"
      has_many_related :images, :class_name => "Breeze::Commerce::ProductImage"
      has_many_related :related_products, :class_name => "Breeze::Commerce::Product" #, :stored_as => :array
      #embeds_many :variants, :class_name => "Breeze::Commerce::Variant"
      #embeds_many :images, :class_name => "Breeze::Commerce::ProductImage"

      field :teaser
      field :short_description
      field :full_description
      field :available_stock, :type => Integer
      field :cost_price_cents, :type => Integer
      field :sell_price_cents, :type => Integer
      field :discounted_sell_price_cents, :type => Integer
      field :content, :markdown => true
      field :available, :type => Boolean

      # field :weight
      # field :height
      # field :width
      # field :depth

      scope :published, where(:available => true)
      scope :in_category, lambda { |category| where(:category_ids => category.id) }
        
      # referenced_in :line_item

      # before_validation :load_variants
      # validates_associated :variants
      validates_with AllVariantsValidValidator
      

      before_save :regenerate_permalink!

      def icon_image
        if self.images.first
          self.images.first.file.url(:breeze_thumb) 
        else
          nil
        end
      end

      def category_tokens

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
      
      def display_price
        self.discounted_sell_price > 0 ? self.discounted_sell_price : self.sell_price
      end
      
      # Override the normal page hierarchy, so that products always appear as children of the root page.
      # This is done so that product pages can display navigation controls, even though they don't appear in the page hierarchy.
      # TODO: Is there a better way to do this?
      def parent
        Breeze::Content::Page.where(:parent_id => nil).first
      end
      def parent_id
        parent.id
      end
      
      protected

      # def load_variants
      #   variants.to_a
      # end

      def regenerate_permalink!
        # TODO: This needs to changed to use the canonical property
        # TODO: Also need to set the parent_id
        category = self.categories.first.name.downcase.parameterize.gsub(/(^[\-]+|[-]+$)/, "")
        self.permalink = "/#{category}/#{slug}" unless store.nil? || slug.blank?
      end
    end
  end
end

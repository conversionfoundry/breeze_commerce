module Breeze
  module Commerce
    class Product < Breeze::Content::Page
      attr_accessible :template, :title, :subtitle, :show_in_navigation, :ssl, :seo_title, :seo_meta_description, :seo_meta_keywords, :show_in_navigation, :teaser, :published, :archived, :tag_ids, :category_ids, :property_ids, :archived, :parent_id, :options

      belongs_to :store, :class_name => "Breeze::Commerce::Store", :inverse_of => :products
      has_and_belongs_to_many :categories, :class_name => "Breeze::Commerce::Category"
      has_and_belongs_to_many :tags, :class_name => "Breeze::Commerce::Tag"
      has_and_belongs_to_many :properties, :class_name => "Breeze::Commerce::Property"

      has_many :images, :class_name => "Breeze::Commerce::ProductImage"
      belongs_to :default_image, :class_name => "Breeze::Commerce::ProductImage"
      
      has_many :product_relationship_children, :class_name => "Breeze::Commerce::ProductRelationship", :inverse_of => :parent_product
      has_many :product_relationship_parents, :class_name => "Breeze::Commerce::ProductRelationship", :inverse_of => :child_product
      has_many :variants, :class_name => "Breeze::Commerce::Variant"

      field :archived, type: Boolean, default: false
      field :published, :type => Boolean, default: false
      field :show_in_navigation, :type => Boolean, :default => false
      field :teaser

      scope :archived, where(:archived => true)
      scope :published, where(:published => true)
      scope :in_category, lambda { |category| where(category_ids: category.id) }
      scope :with_tag, lambda { |tag| where(tag_ids: tag.id) }
      scope :unarchived, where(:archived.in => [ false, nil ])
      scope :unpublished, where(:published.in => [ false, nil ])

      validates_associated :variants

      before_save :regenerate_permalink!

      def name
        title
      end

      def related_products
        product_relationship_children.collect{|relationship| relationship.child_product}
      end

      def icon_image
        if self.images.first
          self.images.first.file.url(:breeze_thumb) 
        else
          nil
        end
      end

      def cost_price
        (self.cost_price_cents || 0) / 100.0
      end

      def sell_price
        (self.sell_price_cents || 0) / 100.0
      end

      def discounted_sell_price
        (self.discounted_sell_price_cents || 0) / 100.0
      end
      
      def display_price_min
        variants.map{|v| v.display_price}.min
      end

      def display_price_max
        variants.map{|v| v.display_price}.max
      end

      def display_price
        display_price_min
      end

      def last_update
        if updated_at.to_date == Time.zone.now.to_date
          updated_at.strftime('%l:%M %p') # e.g. 3:52 PM
        else
          updated_at.strftime('%A %d %B %Y, %l:%M %p') # e.g. 3:52 PM
        end
      end

      def number_of_sales
        count = 0
        variants.unarchived.each do | variant|
          count += variant.number_of_sales
        end
        count
      end

      # Are any of the product's variants discounted?
      def any_variants_discounted?
        variants.unarchived.published.discounted.count > 0
      end

      # Are all of the product's variants discounted?
      def all_variants_discounted?
        variants.unarchived.published.discounted.count == variants.unarchived.published.count
      end

      # Are all the variants the same price?
      def single_display_price?
        price = nil
        variants.unarchived.published.each do |variant|
          if price
            return false unless variant.display_price == price
          else
            price = variant.display_price
          end
        end
        true
      end

    end
  end
end

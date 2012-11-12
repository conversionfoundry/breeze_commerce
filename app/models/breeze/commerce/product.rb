module Breeze
  module Commerce
    class Product < Breeze::Content::Page
      include Mixins::Archivable
      include Mixins::Publishable

      attr_accessible :template, :title, :subtitle, :show_in_navigation, :ssl, :seo_title, :seo_meta_description, :seo_meta_keywords, :show_in_navigation, :teaser, :tag_ids, :property_ids, :parent_id, :options, :slug, :position

      has_and_belongs_to_many :tags, :class_name => "Breeze::Commerce::Tag"
      has_and_belongs_to_many :properties, :class_name => "Breeze::Commerce::Property"

      has_many :images, :class_name => "Breeze::Commerce::ProductImage"
      belongs_to :default_image, :class_name => "Breeze::Commerce::ProductImage"
      
      has_many :product_relationship_children, :class_name => "Breeze::Commerce::ProductRelationship", :inverse_of => :parent_product
      has_many :product_relationship_parents, :class_name => "Breeze::Commerce::ProductRelationship", :inverse_of => :child_product
      has_many :variants, :class_name => "Breeze::Commerce::Variant"

      field :show_in_navigation, :type => Boolean, :default => false
      field :teaser

      default_scope order_by([:title, :asc])
      scope :with_tag, lambda { |tag| where(tag_ids: tag.id) }

      validates_associated :variants

      alias_method :name, :title
      alias_method :name=, :title=

      def related_products
        product_relationship_children.collect{|relationship| relationship.child_product}
      end
      
      def display_price_min
        variants.unarchived.published.map{|v| v.display_price}.min
      end

      def display_price_max
        variants.unarchived.published.map{|v| v.display_price}.max
      end

      def display_price
        display_price_min
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

      # Are any of the product's variants discounted?
      def any_variants_discounted?
        variants.unarchived.published.discounted.exists?
      end

      # Are all of the product's variants discounted?
      def all_variants_discounted?
        all_variants_count = variants.unarchived.published.count
        discounted_variants_count = variants.unarchived.published.discounted.count
        discounted_variants_count > 0 && discounted_variants_count == all_variants_count
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

      # Convenience method for designers
      # ... allows setting up a conditional in product listing theme partials without having to know how to find a tag in the database
      def has_tag_named? tag_name
        tag = Breeze::Commerce::Tag.where( name: tag_name )
        if tag.exists?
          tags.include? tag.first
        else
          false
        end
      end

    end
  end
end

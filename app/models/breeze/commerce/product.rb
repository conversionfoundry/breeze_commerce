module Breeze
  module Commerce
    class Product < Breeze::Content::Page
      include Mixins::Archivable
      include Mixins::Publishable

      FILTERS = [
        {:scope => "all",         :label => "All Products"},
        {:scope => "published", :label => "Published Products"},
        {:scope => "unpublished", :label => "Unpublished Products"}
      ]

      attr_accessible :view, :order, :template, :title, :subtitle,
        :show_in_navigation, :ssl, :seo_title, :seo_meta_description,
        :seo_meta_keywords, :show_in_navigation, :teaser, :tag_ids,
        :property_ids, :parent_id, :options, :slug, :position

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
      scope :title_starts_with, lambda { |prefix| where(title: /^#{prefix}/i) }

      before_validation :set_parent_id
      validates_associated :variants

      alias_method :name, :title
      alias_method :name=, :title=

      def related_products(relationship_kind=nil)
        if relationship_kind
          product_relationship_children.where(kind: relationship_kind).collect(&:child_product)
        else
          product_relationship_children.collect(&:child_product)
        end
      end

      def display_price_min
        variants.unarchived.published.map(&:display_price).min
      end
      alias_method :display_price, :display_price_min

      def display_price_max
        variants.unarchived.published.map(&:display_price).max
      end

      # Are all the variants the same price?
      def single_display_price?
        variants.unarchived.published.map(&:display_price).uniq.size < 2
      end

      # Are any of the product's variants discounted?
      def any_variants_discounted?
        variants.unarchived.published.discounted.exists?
      end

      # Are all of the product's variants discounted?
      def all_variants_discounted?
        variants.present? && !variants.unarchived.published.not_discounted.exists?
      end

      def last_update
        if updated_at.to_date == Time.zone.now.to_date
          updated_at.strftime('%l:%M %p') # e.g. 3:52 PM
        else
          updated_at.strftime('%A %d %B %Y, %l:%M %p') # e.g. 3:52 PM
        end
      end

      def number_of_sales
        variants.unarchived.sum(&:number_of_sales)
      end

      # Convenience method for designers
      # ... allows setting up a conditional in product listing theme partials
      # without having to know how to find a tag in the database
      def has_tag_named? tag_name
        looked_up_tag_id = Breeze::Commerce::Tag.where(name: tag_name).only(:id).first.try(:id)
        tag_ids.include? looked_up_tag_id
      end

      def copy_properties_from( product )
        product.properties.each do | property |
          new_property = properties.create( name: property.name )
          property.options.each do | option |
            new_property.options.create( name: option.name )
          end
        end
      end

      # Return the the number of variants that would be required to have a variant for every combination of options.
      def variants_count_to_cover_all_options
        count = 1
        properties.each do |property|
          count = count * property.options.count
        end
        count
      end

    private

      # If a product is created under store admin, set the root page, if any, as the parent
      def set_parent_id
        unless self.parent_id
          self.parent_id = Breeze::Content::NavigationItem.root.first.id if Breeze::Content::NavigationItem.root.first
        end
      end

    end
  end
end

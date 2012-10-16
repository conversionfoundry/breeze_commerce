module Breeze
  module Commerce
    class Product < Breeze::Content::Page
      attr_accessible :show_in_navigation, :teaser, :available, :archived, :category_ids, :property_ids, :archived

      belongs_to :store, :class_name => "Breeze::Commerce::Store", :inverse_of => :products
      has_and_belongs_to_many :categories, :class_name => "Breeze::Commerce::Category"
      has_and_belongs_to_many :properties, :class_name => "Breeze::Commerce::Property"
      has_many :images, :class_name => "Breeze::Commerce::ProductImage"
      has_many :product_relationship_children, :class_name => "Breeze::Commerce::ProductRelationship", :inverse_of => :parent_product
      has_many :product_relationship_parents, :class_name => "Breeze::Commerce::ProductRelationship", :inverse_of => :child_product
      has_many :variants, :class_name => "Breeze::Commerce::Variant"

      field :archived, type: Boolean, default: false
      field :available, :type => Boolean
      field :show_in_navigation, :type => Boolean, :default => false
      field :teaser

      scope :archived, where(:archived => true)
      scope :available, where(:available => true)
      scope :in_category, lambda { |category| where(category_ids: category.id) }
      scope :published, where(:available => true)
      scope :unarchived, where(:archived.in => [ false, nil ])
      scope :unavailable, where(:available.in => [ false, nil ])

      validates_associated :variants

      before_save :regenerate_permalink!

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

      def category_tokens
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

      def has_line_items?
        # variants.each do |v|
          
        # false
      end

      # Override the normal page hierarchy, so that products always appear as children of the root page.
      # This is done so that product pages can display navigation controls, even though they don't appear in the page hierarchy.
      # TODO: Is there a better way to do this?
      # def parent
      #   Breeze::Content::Page.where(:parent_id => nil).first
      # end
      
      # def parent_id
      #   parent.id
      # end

      # def regenerate_permalink!
      #   # TODO: Also need to set the parent_id
      #   category = self.categories.first # TODO: This needs to changed to use the canonical category
      #   if category
      #     category_slug = category.name.downcase.parameterize.gsub(/(^[\-]+|[-]+$)/, "")
      #     self.permalink = "/#{category}/#{slug}" unless store.nil? || slug.blank?
      #   else
      #     self.permalink = "/#{slug}" unless store.nil? || slug.blank?
      #   end
      # end


    end
  end
end

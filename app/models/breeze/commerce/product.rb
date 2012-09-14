module Breeze
  module Commerce

    #TODO: validates_associated doesn't seem to work here, so I've stuck in this ugly custom validator
    # class AllVariantsValidValidator < ActiveModel::Validator
    #   def validate(product)
    #     product.variants.each do |variant|
    #       unless variant.valid?
    #         product.errors[:base] << "Variant " + variant.name + " is missing a value."
    #       end
    #     end
    #   end
    # end

    class Product < Breeze::Content::Page
      identity :type => String

      belongs_to_related :store, :class_name => "Breeze::Commerce::Store", :inverse_of => :products
      has_and_belongs_to_many :categories, :class_name => "Breeze::Commerce::Category"

      has_and_belongs_to_many :properties, :class_name => "Breeze::Commerce::Property"
      has_many :variants, :class_name => "Breeze::Commerce::Variant"
      has_many_related :images, :class_name => "Breeze::Commerce::ProductImage"


      has_many :product_relationship_children, :class_name => "Breeze::Commerce::ProductRelationship", :inverse_of => :parent_product
      has_many :product_relationship_parents, :class_name => "Breeze::Commerce::ProductRelationship", :inverse_of => :child_product

      field :teaser
      field :available_stock, :type => Integer
      field :content, :markdown => true
      field :available, :type => Boolean
      field :archived, type: Boolean, default: false

      scope :available, where(:available => true)
      scope :unavailable, where(:available.in => [ false, nil ])
      scope :archived, where(:archived => true)
      scope :unarchived, where(:archived.in => [ false, nil ])
      scope :published, where(:available => true)
      scope :in_category, lambda { |category| where(:category_ids => category.id) }
      

      validates_associated :variants
      # validate :all_variants_must_be_valid


      before_save :regenerate_permalink!

      # def all_variants_must_be_valid
      #   variants.each do |variant|
      #     unless variant.valid?
      #       errors[:variants] << "Variant " + variant.name + " is missing a value."
      #     end
      #   end
      # end

      # e.g. Breeze::Commerce::Product is a NavigationItem, but it's managed under the Store admin area
      def has_special_admin?
        true
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
      
      def display_price
        variants.map{|v| v.display_price}.min
      end

      def has_line_items?
        # variants.each do |v|
          
        # false
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

      def regenerate_permalink!
        # TODO: Also need to set the parent_id
        category = self.categories.first # TODO: This needs to changed to use the canonical category
        if category
          category_slug = category.name.downcase.parameterize.gsub(/(^[\-]+|[-]+$)/, "")
          self.permalink = "/#{category}/#{slug}" unless store.nil? || slug.blank?
        else
          self.permalink = "/#{slug}" unless store.nil? || slug.blank?
        end
      end


    end




  end
end

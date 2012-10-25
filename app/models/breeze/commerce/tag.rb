module Breeze
  module Commerce
    class Tag
      include Mongoid::Document
      include Breeze::Content::Mixins::Permalinks
      
      attr_accessible :name, :sort, :position
      field :name
      field :sort
      field :position, :type => Integer

      belongs_to :store, :class_name => "Breeze::Commerce::Store", :inverse_of => :categories
      has_and_belongs_to_many :products, :class_name => "Breeze::Commerce::Product"
      has_and_belongs_to_many :product_lists, :class_name => "Breeze::Commerce::ProductList"

      scope :ordered, order_by([:position, :asc])

      validates_presence_of :name
      # validates_uniqueness_of :name, :slug, :scope => :store_id # TODO: This seems to always be invalid.

      before_save :regenerate_permalink!

      protected

      def regenerate_permalink!
        self.slug = name.downcase.gsub(/[^a-z0-9\-]+/, '-')
        self.permalink = "/#{slug}" unless slug.blank?
      end
    end
  end
end

module Breeze
  module Commerce
    class Tag
      include Mongoid::Document
      
      attr_accessible :name, :sort, :position
      field :name
      field :sort
      field :slug
      field :position, :type => Integer

      has_and_belongs_to_many :products, :class_name => "Breeze::Commerce::Product"
      has_and_belongs_to_many :product_lists, :class_name => "Breeze::Commerce::ProductList"

      default_scope order_by([:name, :asc])
      scope :ordered, order_by([:position, :asc])

      validates_presence_of :name
      # validates_uniqueness_of :name, :slug, :scope => :store_id # TODO: This seems to always be invalid.

      before_validation :fill_in_slug

      protected

      def fill_in_slug
        self.slug = name.downcase.gsub(/[^a-z0-9\-]+/, '-') if name
      end

    end
  end
end

module Breeze
  module Commerce
    class Category
      include Mongoid::Document
      include Breeze::Content::Mixins::Permalinks
      identity :type => String

      field :name
      field :sort
      field :products_per_page, :type => Integer
      field :position, :type => Integer
      field :available, :type => Boolean

      belongs_to_related :store, :class_name => "Breeze::Commerce::Store", :inverse_of => :categories

      scope :ordered, order_by([:position, :asc])

      validates_presence_of :name, :slug
      validates_uniqueness_of :name, :slug, :scope => :store_id

      before_save :regenerate_permalink!

      def to_s
        name
      end

      protected

      def regenerate_permalink!
        self.permalink = "#{store.permalink}/#{slug}" unless store.nil? || slug.blank?
      end
    end
  end
end

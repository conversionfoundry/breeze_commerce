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


      scope :ordered, order_by([:position, :asc])

      validates_presence_of :name

      def to_s
        name
      end
    end
  end
end

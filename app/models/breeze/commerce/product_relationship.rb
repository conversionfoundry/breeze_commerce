module Breeze
  module Commerce
    class ProductRelationship
      include Mongoid::Document

      attr_accessible :parent_product_id, :child_product_id, :kind

      belongs_to :parent_product, :class_name => "Breeze::Commerce::Product", :inverse_of => :product_relationship_children
      belongs_to :child_product, :class_name => "Breeze::Commerce::Product", :inverse_of => :product_relationship_parents

      index({ parent_product_id: 1, child_product_id: 1})

      field :kind

      validates_inclusion_of :kind, :in => Breeze::Commerce::Store.first.product_relationship_kinds

    end
  end
end

module Breeze
  module Commerce
    class ProductRelationship
      include Mongoid::Document

      RELATIONSHIPS = [ "is_related_to", "is_similar_to", "is_complemented_by", "goes_well_with", "could_be_upsold_to" ]

      attr_accessible :parent_product_id, :child_product_id, :kind

      belongs_to :parent_product, :class_name => "Breeze::Commerce::Product", :inverse_of => :product_relationship_children
      belongs_to :child_product, :class_name => "Breeze::Commerce::Product", :inverse_of => :product_relationship_parents
      
      field :kind

      validates_inclusion_of :kind, :in => RELATIONSHIPS

    end
  end
end

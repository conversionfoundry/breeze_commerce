module Breeze
  module Commerce
    class Option
      include Mongoid::Document

      belongs_to :property, :class_name => "Breeze::Commerce::Property"
      has_and_belongs_to_many :variant, :class_name => "Breeze::Commerce::Variant"

      attr_accessible :name, :property_id
      field :name
      field :position, :type => Integer
      validates_presence_of :name, :property_id

      scope :ordered, order_by(:position.asc)

    end
  end
end

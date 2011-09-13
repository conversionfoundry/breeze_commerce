module Breeze
  module Commerce
    class Variant
      include Mongoid::Document

      belongs_to_related :product, :class_name => "Breeze::Commerce::Product"
      #embedded_in :product, :class_name => "Breeze::Commerce::Variant", :inverse_of => :variants

      field :name
      field :description
      field :available, :type => Boolean

      validates :name, :presence => true
    end
  end
end

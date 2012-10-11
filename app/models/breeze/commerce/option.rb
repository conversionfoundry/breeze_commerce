module Breeze
  module Commerce
    class Option 
      include Mongoid::Document

      belongs_to :property, :class_name => "Breeze::Commerce::Property"
      has_and_belongs_to_many :variant, :class_name => "Breeze::Commerce::Variant"
      

      field name      
      validates_presence_of :name
      
    end
  end
end

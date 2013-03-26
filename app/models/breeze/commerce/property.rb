module Breeze
  module Commerce
    class Property
      include Mongoid::Document

      attr_accessible :product_ids, :name, :options, :options_attributes

      has_and_belongs_to_many :product, :class_name => "Breeze::Commerce::Product"
      has_many :options, :class_name => "Breeze::Commerce::Option", dependent: :destroy
      accepts_nested_attributes_for :options, allow_destroy: true, reject_if: lambda { |o| o[:name].blank? }
      
      field :name      

      validates_presence_of :name
      validates_associated :options

    end
  end
end

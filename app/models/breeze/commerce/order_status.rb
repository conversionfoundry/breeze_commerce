module Breeze
  module Commerce
    class OrderStatus
      include Mongoid::Document
      
      field :name
      field :description
      
      belongs_to :store, :class_name => "Breeze::Commerce::Store", :inverse_of => :order_statuses
      has_many :orders, :class_name => "Breeze::Commerce::Order", :inverse_of => :order_statuses
      
      validates_presence_of :name

    end
  end
end

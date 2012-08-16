module Breeze
  module Commerce
    class Customer < Breeze::Account::Customer
      belongs_to :store, :class_name => "Breeze::Commerce::Store", :inverse_of => :customers
      has_many :orders, :class_name => "Breeze::Commerce::Order"
      

      # field name      
      # validates_presence_of :name
      
      def last_order
        orders.last
      end
      
    end
  end
end

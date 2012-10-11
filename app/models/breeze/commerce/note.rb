module Breeze
  module Commerce
    class Note 
      include Mongoid::Document

      embedded_in :order, :class_name => "Breeze::Commerce::Order", :inverse_of => :notes      
      belongs_to :user, :class_name => "Breeze::Admin::User"      

      field :body_text
      validates_presence_of :body_text
      
    end
  end
end

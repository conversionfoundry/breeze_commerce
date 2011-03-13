module Breeze
  module Commerce
    class Category
      include Mongoid::Document
      identity :type => String

      field :name

      
    end
  end
end

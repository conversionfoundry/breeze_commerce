module Breeze
  module Commerce
    class Address
      include Mongoid::Document
      
      field :first_name
    end
  end
end

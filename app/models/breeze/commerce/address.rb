module Breeze
  module Commerce
    class Address
      include Mongoid::Document
      
      field :first_name
      field :last_name
      field :phone
    end
  end
end

module Breeze
  module Commerce
    class State
      include Mongoid::Document
      
      field :name
    end
  end
end

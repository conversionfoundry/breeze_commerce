module Breeze
  module Commerce
    module ContentsHelper
      include Breeze::Commerce::CurrentOrder

    	def currency
    		Breeze::Commerce::Store.first.currency
    	end

    end
  end
end


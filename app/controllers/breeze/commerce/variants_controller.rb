module Breeze
  module Commerce
    class VariantsController < Breeze::Commerce::Controller

    	# Return the variants that have all of a given array of option_ids
      def filter
        @variants = Breeze::Commerce::Variant.unarchived.published.where(:product_id => params[:product_id], :option_ids.all => params[:option_ids]) 
      end

    end
  end
end

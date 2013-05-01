module Breeze
  module Commerce
    class VariantsController < Breeze::Commerce::Controller

    	# Return the variants that have all of a given array of option_ids
      def filter
        @product = Breeze::Commerce::Product.find params[:product_id]
        @variants = Breeze::Commerce::Variant.unarchived.published.ordered.where(:product_id => params[:product_id], :option_ids.all => params[:option_ids])
      end

    end
  end
end

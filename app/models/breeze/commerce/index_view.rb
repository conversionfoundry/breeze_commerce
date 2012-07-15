module Breeze
  module Commerce
    class IndexView < Breeze::Commerce::View

      # def variables_for_render
      #   returning super do |vars|
      #     vars[:products] = products
      #   end
      # end

      def variables_for_render
        super.tap do |vars|
          vars[:products] = products
        end
      end
      
    end
  end
end

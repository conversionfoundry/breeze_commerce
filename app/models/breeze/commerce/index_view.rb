module Breeze
  module Commerce
    class IndexView < View

      def variables_for_render
        returning super do |vars|
          vars[:products] = products
        end
      end
    end
  end
end

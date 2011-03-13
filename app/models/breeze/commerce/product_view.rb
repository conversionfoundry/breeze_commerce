module Breeze
  module Commerce
    class ProductView < View
      attr_accessor :slug

      def product
        Breeze::Commerce::Product.where(:slug => slug).first
      end

      def set_url_params(match)
        super
        self.slug = match[3]
      end

      def variables_for_render
        returning super do |vars|
          vars[:product] = product
        end
      end
    end
  end
end

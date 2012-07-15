module Breeze
  module Commerce
    class ProductView < View
      attr_accessor :slug

      def product
        store.products.where(:slug => slug).first
      end

      def set_url_params(match)
        super
        self.slug = match[2].gsub('/', '')
      end

      def template
        if content.template.blank?
          "breeze/commerce/product"
        else
          content.template
        end
      end

      def variables_for_render
        super.tap do |vars|
          vars[:products] = products
        end
      end
    end
  end
end

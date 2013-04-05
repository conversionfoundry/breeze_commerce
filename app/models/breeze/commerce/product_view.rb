module Breeze
  module Commerce
    class ProductView < View
      attr_accessor :slug

      def set_url_params(match)
        super
        self.slug = match[2].gsub('/', '')
      end

      def template
        if content.template.blank?
          "product"
        else
          content.template
        end
      end

      def variables_for_render
        super.tap do |vars|
          vars[:product] = page  # Allows using "product" in layout instead of "page".
        end
      end

    end
  end
end

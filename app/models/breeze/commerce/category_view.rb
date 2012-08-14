module Breeze
  module Commerce
    class CategoryView < View
      attr_accessor :slug

      def category
        @category ||= store.categories.where(:slug => slug).first
      end

      def products
        Product.where(:category_ids => category.try(:id))
      end

      def set_url_params(match)
        super
        self.slug = match[2].gsub('/', '')
      end

      def variables_for_render
        super.tap do |vars|
          vars[:category] = category
        end
      end
    end
  end
end


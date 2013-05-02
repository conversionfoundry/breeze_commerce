module Breeze
  module Commerce
    class ProductPlaceable < Breeze::Content::Item

      attr_accessible :product_id, :container_id, :region, :view

      belongs_to :product, class_name: "Breeze::Commerce::Product"

      include Breeze::Content::Mixins::Placeable

      def to_erb(view, page_number=1)
        view.controller.render_to_string partial: "partials/commerce/product_placeable", layout: false, locals: {:@product => product}
      end

    end
  end
end

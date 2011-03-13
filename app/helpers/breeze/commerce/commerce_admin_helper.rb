module Breeze
  module Commerce
    module CommerceAdminHelper
      def commerce_menu
        content_tag :ul, [
          commerce_menu_item("Commerce overview", admin_commerce_root_path),
          commerce_menu_item("Products", admin_commerce_products_path),
          commerce_menu_item("View products", "/products", :target => :_blank)
        ].join.html_safe, :class => :actions
      end

      def commerce_menu_item(name, path, options = {})
        content_tag :li, link_to(name.html_safe, path.is_a?(Regexp) ? path.source : path.to_s, options), :class => "#{:active if path === request.path}"
      end
    end
  end
end

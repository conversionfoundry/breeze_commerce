module Breeze
  module Commerce
    module CommerceAdminHelper
      def commerce_menu
        content_tag :ul, [
          commerce_menu_item("Orders", admin_store_orders_path),
          commerce_menu_item("Customers", ""),
          commerce_menu_item("Products", admin_store_products_path),
          commerce_menu_item("Categories", admin_store_categories_path),
          commerce_menu_item("Coupons", admin_store_coupons_path),
          commerce_menu_item("Shipping Costs", ""),
          commerce_menu_item("Settings", admin_store_settings_path)
        ].join.html_safe, :class => :actions
      end

      def commerce_menu_item(name, path, options = {})
        content_tag :li, link_to(name.html_safe, path.is_a?(Regexp) ? path.source : path.to_s, options), :class => "#{:active if path === request.path}"
      end
    end
  end
end

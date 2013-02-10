module Breeze
  module Commerce
    module AdminHelper
      include Breeze::Commerce::ContentsHelper
      
      def commerce_menu
        content_tag :ul, [
          commerce_menu_item("Orders", breeze.admin_store_orders_path, badge( Breeze::Commerce::Order.unarchived.show_in_admin.count )),
          commerce_menu_item("Registered Customers", breeze.admin_store_customers_path, badge( Breeze::Commerce::Customer.unarchived.count )),
          commerce_menu_item("Products", breeze.admin_store_products_path, badge( Breeze::Commerce::Product.unarchived.count )),
          commerce_menu_item("Tags", breeze.admin_store_tags_path, badge( Breeze::Commerce::Tag.count )),
          commerce_menu_item("Shipping", breeze.admin_store_shipping_methods_path, badge( Breeze::Commerce::ShippingMethod.unarchived.count )),
          commerce_menu_item("Settings", breeze.edit_admin_store_store_path)
        ].join.html_safe, :class => 'store-actions'
      end

      def badge text
        content_tag :span, text, class: "badge item-count"
      end

      def commerce_menu_item(name, path, additional_html = '', options = {})
        content_tag :li, link_to( (name + additional_html).html_safe, path.is_a?(Regexp) ? path.source : path.to_s, options), id: "menu-item-#{name.html_safe.downcase.parameterize.underscore}", class: "#{:active if path === request.path}"
      end

      def at_a_glance(count, label, link = nil, options = {})
        "".tap do |html|
          html << "<tr>"
          html << "<td class=\"count\">#{count}</td>"
          html << "<td class=\"label\">"
          html << link_to_unless(link.blank?, label.gsub(/(\w+)\(s\)/) { count == 1 ? $1 : $1.pluralize }, link, options)
          html << "</td>"
          html << "</tr>"
        end.html_safe
      end
      
      def uploadable_image(object, name, options)
        src = if object.send(:"#{name}?") && (image = object.send(name))
          image.respond_to?(:url) ? image.url(:thumbnail) : image
        else
          "http://placehold.it/#{options[:width] || 100}x#{options[:height] || 100}"
        end
        object_name = options[:object_name] || object.class.name.demodulize.underscore
    
        image_options = {
          :class => "uploadable",
          :id => options[:id] || "#{object_name}_#{name}",
          :"data-name" => options[:name] || "#{object_name}[#{name}]",
          :"data-session-key" => Rails.application.config.session_options[:key],
          :"data-session-id" => cookies[Rails.application.config.session_options[:key]]
        }

        image_options[:"data-url"] = options[:url] if options[:url].present?
        image_tag src, image_options
      end

      # Filters for index pages
      # Source: http://www.idolhands.com/ruby-on-rails/guides-tips-and-tutorials/add-filters-to-views-using-named-scopes-in-rails
      def select_tag_for_filter(model, nvpairs, params)
        options = { :query => params[:query] }
        _url = url_for(eval("#{model}_url(options)"))
        _html = %{<label for="show">Show:</label><br />}
        _html << %{<select name="show" id="show"}
        _html << %{onchange="window.location='#{_url}' + '?show=' + this.value">}
        nvpairs.each do |pair|
          _html << %{<option value="#{pair[:scope]}"}
          if params[:show] == pair[:scope] || ((params[:show].nil? || 
      params[:show].empty?) && pair[:scope] == "all")
            _html << %{ selected="selected"}
          end
          _html << %{>#{pair[:label]}}
          _html << %{</option>}
        end
        _html << %{</select>}
      end

    end
  end
end

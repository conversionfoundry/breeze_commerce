module Breeze
  module Commerce
    module AdminHelper
      include Breeze::Commerce::ContentsHelper

      def commerce_menu
        content_tag :ul, [
          commerce_menu_item("Orders", breeze.admin_store_orders_path, badge( Breeze::Commerce::Order.unarchived.actionable.count )),
          commerce_menu_item("Registered Customers", breeze.admin_store_customers_path, badge( Breeze::Commerce::Customer.unarchived.count )),
          commerce_menu_item("Products", breeze.admin_store_products_path, badge( Breeze::Commerce::Product.unarchived.count )),
          commerce_menu_item("Tags", breeze.admin_store_tags_path, badge( Breeze::Commerce::Tag.count )),
          commerce_menu_item("Discounts & Coupons", breeze.admin_store_coupons_path, badge( Breeze::Commerce::Coupons::Coupon.count )),
          commerce_menu_item("Shipping", breeze.admin_store_shipping_methods_path, badge( Breeze::Commerce::Shipping::ShippingMethod.unarchived.count )),
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

      # Sortable table columns
      # http://railscasts.com/episodes/228-sortable-table-columns?view=asciicast
      def sortable(column, title = nil)
        title ||= column.titleize
        css_class = (column == sort_method) ? "current #{sort_direction}" : nil
        direction = (column == sort_method && sort_direction == "asc") ? "desc" : "asc"
        link_to( {sort: column, direction: direction}, {:class => css_class} ) do
          html = title
          triangle = sort_direction == "asc" ? "&#9650;" : "&#9660;"
          html += ("&nbsp;<i class='icon-sort_order_#{sort_direction}'>#{triangle}</i>") if (column == sort_method)
          html.html_safe
        end
      end

      def line_item_string(line_item)
        content_tag :li, class: "line_item" do
          "".tap do |html|
            html << line_item.quantity.to_s
            html << " &times; "
            html << line_item.name
            html << " ( #{line_item.sku_code} )"
            if line_item.customer_message
              html << "<p class='customer_message'>#{line_item.customer_message}</p>"
            end
        end.html_safe
        end
      end

      # Add new items to nested attribute fields
      # Based on http://railscasts.com/episodes/197-nested-model-form-part-2?view=asciicast
      def link_to_add_fields(name, f, association, partial)
        new_object = f.object.class.reflect_on_association(association).klass.new
        fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |association_fields|
          render partial, form: association_fields
        end
        link_to_function name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", class: "btn add"
      end

      # Filters for index pages
      # Source: http://www.idolhands.com/ruby-on-rails/guides-tips-and-tutorials/add-filters-to-views-using-named-scopes-in-rails
      def select_tag_for_filter(model, nvpairs, params)
        options = { :query => params[:query] }
        url = url_for(eval("admin_store_#{model}_url(options)"))
        html = %{<label for="show">Show:</label>}
        html << %{<select name="show" id="show"}
        starting_with_param = params[:show] ? "starting_with=#{params[:starting_with]}&" : ""
        html << %{onchange="window.location='#{url}?#{starting_with_param}show=' + this.value">}
        nvpairs.each do |pair|
          html << %{<option value="#{pair[:scope]}"}
          if params[:show] == pair[:scope] || ((params[:show].nil? || params[:show].empty?) && pair[:scope] == "all")
            html << %{ selected="selected"}
          end
          html << %{>#{pair[:label]}}
          html << %{</option>}
        end
        html << %{</select>}
        html.html_safe
      end

      def select_tag_for_alphabet(model, params)
        options = { :query => params[:query] }
        url = url_for(eval("admin_store_#{model}_url(options)"))
        html = %{<label for="starting_with">Starting with:</label>}
        html << %{<select name="starting_with" id="starting_with"}
        show_param = params[:show] ? "show=#{params[:show]}&" : ""
        html << %{onchange="window.location='#{url}?#{show_param}starting_with=' + this.value">}
        letters = ['Any letter'] + ('a'..'z').to_a + ('0'..'9').to_a
        letters.each do |letter|
          html << %{<option value="#{letter}"}
          if params[:starting_with] == letter || ((params[:starting_with].nil? || params[:starting_with].empty?) && letter == "all")
            html << %{ selected="selected"}
          end
          html << %{>#{letter.humanize}}
          html << %{</option>}
        end
        html << %{</select>}
        html.html_safe
      end


    end
  end
end

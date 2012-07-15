module Breeze
  module Commerce
    class Store #< Breeze::Content::Page
      include Mongoid::Document
      identity :type => String
      
      has_many_related :categories, :class_name => "Breeze::Commerce::Category"
      has_many_related :products, :class_name => "Breeze::Commerce::Product"
      has_many_related :coupons, :class_name => "Breeze::Commerce::Coupon"
      has_many :customers, :class_name => "Breeze::Commerce::Customer"
      has_many :orders, :class_name => "Breeze::Commerce::Order"
      
      def available_products
        products.select{|product| product.available}
      end

      def unavailable_products
        products.select{|product| not product.available}
      end
      
      # def view_for(controller, request)
      #   if controller.admin_signed_in? && request.params[:view]
      #     returning views.by_name(request.params[:view]) do |view|
      #       view.with_url_params Breeze::Commerce::PERMALINK.match(permalink)
      #     end
      #   else
      #     view_from_permalink request.path
      #   end
      # end
      # 
      # def method_missing(sym, *args, &block)
      #   if sym.to_s =~ /^(.+)_view$/
      #     view_name = $1
      #     views.detect { |v| v.name == view_name } ||
      #       views.build({ :name => view_name}, "Breeze::Commerce::#{view_name.camelize}View".constantize)
      #   else
      #     super
      #   end
      # end
      # 
      # def view_from_permalink(permalink)
      #   match = Breeze::Commerce::PERMALINK.match(permalink) || {}
      #   Rails.logger.debug "match[0]: " + match[0].to_s
      #   Rails.logger.debug "match[1]: " + match[1].to_s
      #   Rails.logger.debug "match[2]: " + match[2].to_s
      #   Rails.logger.debug "match[3]: " + match[3].to_s
      #   view = if match[3]  # canonical product
      #             product_view
      #          elsif match[2] # product or category
      #            Category.where(:permalink => match[0]).count > 0 ? category_view : product_view
      #          else
      #            index_view
      #          end
      #   view.with_url_params match
      # end 
      # 
      # def self.find_by_permalink(permalink)
      #   if permalink =~ Breeze::Commerce::PERMALINK
      #     permalink = $1
      #     where(:permalink => permalink).first
      #   end
      # end
    end
  end
end

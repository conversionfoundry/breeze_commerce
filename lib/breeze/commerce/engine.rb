module Breeze
  module Commerce
    class Engine < ::Rails::Engine
      isolate_namespace Breeze::Commerce

      if Rails.version >= '3.1'
        initializer :assets do |config|
           Rails.application.config.assets.paths += [ root.join("app/assets/breeze/javascripts").to_s ]

        end
      end

      config.to_prepare do
        ApplicationController.helper Breeze::Commerce::ContentsHelper
        ApplicationController.helper Breeze::Commerce::CommerceAdminHelper
        Breeze::Content.register_class Breeze::Commerce::Store
        Breeze::Content.register_class Breeze::Commerce::ProductList
        Breeze::Content.register_class Breeze::Commerce::Minicart
        Breeze::Content.register_class Breeze::Commerce::CustomerLoginForm
      end

      config.after_initialize do
        # Make sure Breeze knows that products are a subclass of Breeze::Content::Page
        Breeze::Content.register_class Breeze::Commerce::Product
      end

      # Patch the pages controller so archived products don't appear in the heirarchy on the Pages tab.
      # http://www.cowboycoded.com/2010/08/02/hooking-in-your-rails-3-engine-or-railtie-initializer-in-the-right-place/
      # Note that there's nothing special about :disable_dependency_loading – it's used solely because it's the last step in the initialization process
      initializer "breeze_commerce.skip_archived_products_in_page_hierarchy", :after=> :disable_dependency_loading do
        Breeze::Admin::PagesController.class_eval do
          def pages
            @pages ||= Breeze::Content::NavigationItem.all.order_by([[ :position, :asc ]]).reject{|i| i.respond_to?(:archived) && i.archived}.to_a
          end
        end
      end

      config.generators do |g|
        g.test_framework :rspec, :view_specs => false
      end      

    end
  end
end


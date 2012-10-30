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

      config.generators do |g|
        g.test_framework :rspec, :view_specs => false
      end      

    end
  end
end


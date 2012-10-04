module Breeze
  module Commerce
    class Engine < ::Rails::Engine
      #include Breeze::Engine
      isolate_namespace Breeze::Commerce

      # initializer "breeze.assets.precompile" do |app|
      #   app.config.assets.prefix = "/cached"
      #   app.config.assets.precompile += [ "breeze/*" ]
      # end

      # initializer "foo" do |app|
      #   app.config.assets.paths += [ root.join("app/assets/breeze/javascripts").to_s ]
      #   # binding.pry
      #   # app.config.assets.precompile << 'breeze_commerce.js'
      # end

      if Rails.version >= '3.1'
        initializer :assets do |config|
           Rails.application.config.assets.paths += [ root.join("app/assets/breeze/javascripts").to_s ]
           # Rails.application.config.assets.paths += [ root.join("app/assets/breeze/javascripts/galleria").to_s ]
           # Rails.application.config.assets.precompile += %w( breeze/jquery.multi-select.js alchemy/alchemy.css alchemy/print.css )
          # binding.pry
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


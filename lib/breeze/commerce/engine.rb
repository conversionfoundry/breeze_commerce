module Breeze
  module Commerce
    class Engine < ::Rails::Engine
      #include Breeze::Engine
      isolate_namespace Breeze::Commerce


      config.to_prepare do
        ApplicationController.helper Breeze::Commerce::ContentsHelper
        ApplicationController.helper Breeze::Commerce::CommerceAdminHelper
        Breeze::Content.register_class Breeze::Commerce::Store
        Breeze::Content.register_class Breeze::Commerce::ProductList
        Breeze::Content.register_class Breeze::Commerce::Cart # TODO: Rename to Minicart
        Breeze::Content.register_class Breeze::Commerce::CustomerLoginForm
      end

      config.generators do |g|
        g.test_framework :rspec, :view_specs => false
      end      

    end
  end
end


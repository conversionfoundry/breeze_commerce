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
        Breeze::Content.register_class Breeze::Commerce::Cart
      end
      

    end
  end
end


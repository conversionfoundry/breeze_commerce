module Breeze
  module Commerce
    class Controller < Breeze::ContentsController
      helper Breeze::ContentsHelper
      helper Breeze::Commerce::ContentsHelper
      helper Breeze::Commerce::AddressesHelper

    protected
   
      def store
        Breeze::Commerce::Store.first
      end
      helper_method :store

    end
  end
end
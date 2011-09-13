module Admin
  module Breeze
    module Commerce
      class OrdersController < Breeze::Commerce::Controller
        def index
          @orders = ::Breeze::Commerce::Order.all
        end
      end
    end
  end
end

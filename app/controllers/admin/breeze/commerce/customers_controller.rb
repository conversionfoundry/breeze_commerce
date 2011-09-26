module Admin
  module Breeze
    module Commerce
      class CustomersController < Breeze::Commerce::Controller
        def index
          @customers = ::Breeze::Account::Customer.all
        end
      end
    end
  end
end

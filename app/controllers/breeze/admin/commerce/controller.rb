module Breeze
  module Admin
    module Commerce
      class Controller < ::Breeze::Admin::AdminController
        helper ::Breeze::Commerce::AdminHelper
        helper Breeze::Commerce::AddressesHelper
        before_filter :check_for_stores
        before_filter :check_permissions

        protected
  
        # if there's no store, create one
        def check_for_stores
          unless store
            Breeze::Commerce::Store.create
          end
        end

        def check_permissions
          authorize! :manage, Breeze::Commerce::Store
        end

        def store
          @store ||= if session[:store_id].present?
            ::Breeze::Commerce::Store.where(:_id => session[:store_id]).first
          end || ::Breeze::Commerce::Store.first
          session[:store_id] = @store.try(:id)
          @store
        end
        helper_method :store

        def application_name
          Rails.application.class.to_s.split("::").first
        end
      end
    end
  end
end

module Breeze
  module Admin
    module Commerce
      class Controller < ::Breeze::Admin::AdminController
        helper ::Breeze::Commerce::CommerceAdminHelper
        before_filter :check_for_stores, :except => [ :setup_default ]
        before_filter :check_permissions

      protected
        def check_for_stores
          unless store
            render :action => "no_store"
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
      end
    end
  end
end

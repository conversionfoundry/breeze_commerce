module Breeze
  module Commerce
    class Controller < Breeze::ContentsController
      helper Breeze::ContentsHelper
      helper Breeze::Commerce::ContentsHelper
      before_filter :check_for_stores, :except => [ :setup_default ]

    protected
      def check_for_stores
        unless store
          render :action => "no_store"
        end
      end
    
      def store
        @store ||= if session[:store_id].present?
          Breeze::Commerce::Store.where(:_id => session[:store_id]).first
        end || Breeze::Commerce::Store.first
        session[:store_id] = @store.try(:id)
        @store
      end
      helper_method :store

    end
  end
end
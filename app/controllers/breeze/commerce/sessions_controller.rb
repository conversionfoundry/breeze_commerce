#  This overrides the Devise sessions controller, to allow different redirects when commerce customers sign in/out
module Breeze
  module Commerce
    class SessionsController < Devise::SessionsController
      
      # If login fails, return to the page you came from
      def new
        redirect_to request.referrer
      end

      def create
        # resource = warden.authenticate!(auth_options)
        resource = warden.authenticate!({:scope => :customer})
        set_flash_message(:notice, :signed_in) if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => after_sign_in_path_for(resource)
      end

      protected
  
      # After sign-in, return to the page you signed in from
      def after_sign_in_path_for(resource_or_scope)
        request.referrer
      end

      # After sign-out, return to the page you signed in from
      def after_sign_out_path_for(resource_or_scope)
        Breeze::Commerce::Store.first.home_page.permalink
      end

    end
  end
end
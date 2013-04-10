#  This overrides the Devise sessions controller, to allow different redirects when commerce customers sign in/out
module Breeze
  module Commerce
    class SessionsController < Devise::SessionsController
      
      # If login fails, return to the page you came from
      def new
        redirect_to unsuccessful_login_path
      end

      def create
        # customer = warden.authenticate!(auth_options)
        customer = warden.authenticate!({:scope => :customer, recall: "breeze/commerce/sessions#new"})
        set_flash_message(:notice, :signed_in) if is_navigational_format?
        sign_in(:commerce_customer, customer)
        respond_with customer, :location => after_sign_in_path_for(customer)
      end

    protected
  
      # After sign-in, return to the page you signed in from
      def after_sign_in_path_for(resource_or_scope)
        request.referrer
      end

      # After sign-out, return to store's home page
      def after_sign_out_path_for(resource_or_scope)
        Breeze::Commerce::Store.first.home_page.permalink
      end

      # If login is unsuccessful, return to the page you tried to sign in from
      def unsuccessful_login_path
        request.referrer
      end
    end
  end
end
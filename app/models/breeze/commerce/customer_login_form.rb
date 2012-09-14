module Breeze
  module Commerce
    class CustomerLoginForm < Breeze::Content::Item
      
      field :title, :markdown => false

      include Breeze::Content::Mixins::Placeable
            
      def to_erb(view)
        session = view.controller.session
        content = view.controller.render_to_string :partial => "partials/commerce/customer_login_form", :layout => false
      end
    end
  end
end
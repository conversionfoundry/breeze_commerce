# A placeable block for the small version of the shopping cart
# The full cart is a view for orders#edit
module Breeze
  module Commerce
    class Minicart < Breeze::Content::Item
      
      attr_accessible :title
      field :title, :markdown => false

      include Breeze::Content::Mixins::Placeable
      include Breeze::Commerce::CurrentOrder
            
      def to_erb(view)
        session = view.controller.session
        content = view.controller.render_to_string :partial => "partials/commerce/minicart", :layout => false, :locals => {title: title, order: current_order(session)}
      end
    end
  end
end
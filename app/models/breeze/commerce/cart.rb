module Breeze
  module Commerce
    class Cart < Breeze::Content::Item
      
      field :title, :markdown => false

      include Breeze::Content::Mixins::Placeable
      include Breeze::Commerce::CurrentOrder
            
      def to_erb(view)
        
        # # content
        # store = Breeze::Commerce::Store.first # Assuming one store per site at this stage
        # property_name = ""
        # products = store.products
        # 
        # women = store.categories.where(:name => 'Women').first
        # men = store.categories.where(:name => 'Men').first
        # categories = self.categories
        # 
        # categories.each do |category|
        #   products = products & category.products
        # end
        # # products = store.products.select{|p| p.categories.include?(women)}
        # content = "<h3>#{title}</h3>"
        session = view.controller.session
        content = view.controller.render_to_string :partial => "partials/commerce/cart", :layout => false, :locals => {:order => current_order(view.controller.session)}

        
      end
    end
  end
end
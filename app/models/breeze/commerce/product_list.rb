module Breeze
  module Commerce
    class ProductList < Breeze::Content::Item
      
      has_and_belongs_to_many :categories, :class_name => "Breeze::Commerce::Category"
      field :title, :markdown => false

      include Breeze::Content::Mixins::Placeable
      
      # TODO: When properties are available for products, provide a better form
      
      def to_erb(view)
        # content
        store = Breeze::Commerce::Store.first # Assuming one store per site at this stage
        property_name = ""
        products = store.available_products
        
        women = store.categories.where(:name => 'Women').first
        men = store.categories.where(:name => 'Men').first
        categories = self.categories
        
        categories.each do |category|
          products = products & category.products
        end
        # products = store.products.select{|p| p.categories.include?(women)}
        content = "<h3>#{title}</h3>"
        
        
        content += view.controller.render_to_string :partial => "partials/commerce/products", :layout => false, :locals => {:products => products}
        
      end
    end
  end
end
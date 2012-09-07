module Breeze
  module Commerce
    class ProductList < Breeze::Content::Item
      
      has_and_belongs_to_many :categories, :class_name => "Breeze::Commerce::Category"
      belongs_to :product, :class_name => "Breeze::Commerce::Product"
      field :title, :markdown => false
      field :list_type # :category or :related

      include Breeze::Content::Mixins::Placeable
      
      # TODO: When properties are available for products, provide a better form
      
      def to_erb(view)
        store = Breeze::Commerce::Store.first # Assuming one store per site at this stage
        products = store.available_products
        content = "<h3>#{title}</h3>"
        
        if list_type == 'category'
          categories = self.categories
          categories.each do |category|
            products = products & category.products
          end
          content += view.controller.render_to_string :partial => "partials/commerce/products", :layout => false, :locals => {:products => products}
        elsif list_type == 'related'
          content += view.controller.render_to_string :partial => "partials/commerce/products", :layout => false, :locals => {:products => product.related_products}
        else
          content += 'Product List needs editing'
        end

        return content

      end
    end
  end
end
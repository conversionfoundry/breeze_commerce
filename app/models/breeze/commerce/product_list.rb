module Breeze
  module Commerce
    class ProductList < Breeze::Content::Item
          
      attr_accessible :title, :list_type, :product_id, :category_ids, :container_id, :region, :view

      has_and_belongs_to_many :categories, :class_name => "Breeze::Commerce::Category"
      belongs_to :product, :class_name => "Breeze::Commerce::Product"

      field :title, :markdown => false
      field :list_type # :category or :related # TODO: set default to :category

      validates_inclusion_of :list_type, :in => [ "category", "related" ]


      include Breeze::Content::Mixins::Placeable
            
      def to_erb(view)
        store = Breeze::Commerce::Store.first # Assuming one store per site at this stage
        products = store ? store.products.available.unarchived : []
        content = "<h3>#{title}</h3>"

        if list_type == 'category'
          classes = 'categories'
          self.categories.each do |category|
            products = products & category.products
            classes += ' category-' + category.slug
          end
          content += view.controller.render_to_string :partial => "partials/commerce/products", :layout => false, :locals => {:products => products, :classes => classes}

        elsif list_type == 'related'
          classes = 'related_products'
          classes += ' related_to-' + product.slug
          content += view.controller.render_to_string :partial => "partials/commerce/products", :layout => false, :locals => {:products => product.related_products, :classes => classes}
        else
          content += 'Product List needs editing'
        end

        return content

      end
    end
  end
end
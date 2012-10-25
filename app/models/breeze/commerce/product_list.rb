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
            
      def products
        if list_type == 'category'
          store = Breeze::Commerce::Store.first # Assuming one store per site at this stage
          product_array = store ? store.products.published.unarchived : []
          self.categories.each do |category|
            product_array = product_array & category.products
          end
          product_array
        elsif list_type == 'related'
          product.related_products
        else
          []
        end
      end

      def to_erb(view)
        view.controller.render_to_string :partial => "partials/commerce/products", :layout => false, :locals => {:@product_list => self, :@products => products}
      end

    end
  end
end
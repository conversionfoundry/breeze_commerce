require 'kaminari'

module Breeze
  module Commerce
    class ProductList < Breeze::Content::Item
          
      attr_accessible :title, :list_type, :product_id, :tag_ids, :container_id, :region, :view, :use_pagination, :products_per_page

      has_and_belongs_to_many :tags, class_name: "Breeze::Commerce::Tag"
      belongs_to :product, class_name: "Breeze::Commerce::Product"

      field :title, markdown: false
      field :list_type, default: 'by_tags' # :by_tags or :related
      field :use_pagination, type: Boolean
      field :products_per_page, type: Integer, default: 20

      validates_inclusion_of :list_type, :in => [ "by_tags", "related" ]


      include Breeze::Content::Mixins::Placeable
            
      def products
        if list_type == 'by_tags' 
          product_array = Breeze::Commerce::Product.published.unarchived
          self.tags.each do |tag|
            product_array = product_array & tag.products
          end
          product_array
        elsif list_type == 'related'
          product.related_products
        else
          []
        end
      end

      def show_pagination?
        use_pagination && products_per_page < products.count
      end

      def to_erb(view, page_number=1)
        products_local = use_pagination? ? Kaminari.paginate_array(products).page(page_number).per(products_per_page) : products
        view.controller.render_to_string partial: "partials/commerce/products", layout: false, locals: {:@product_list => self, :@products => products_local}
      end

    end
  end
end
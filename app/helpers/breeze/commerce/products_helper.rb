module Breeze::Commerce
  module ProductsHelper
    
    def product_list_class(product_list)
      if product_list.list_type == 'by_tags'
        classes = 'tags'
        product_list.tags.each{ |tag| classes += ' tag-' + tag.slug }
      elsif product_list.list_type == 'related'
        classes = "related_products related_to-#{@product_list.product.slug}"
      else
        classes = ''
      end
    end

    def product_class(product, product_counter, product_count)
      classes = 'product'
      classes += ' ' + product.tags.map{|c| c.slug}.join(' ')
      classes += ' product-some_variants_discounted' if product.any_variants_discounted? 
      classes += ' product-all_variants_discounted' if product.all_variants_discounted?
      classes += ' product-single_display_price' if product.single_display_price?
    end
  end
end

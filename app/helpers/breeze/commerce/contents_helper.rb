module Breeze
  module Commerce
    module ContentsHelper
      include Breeze::Commerce::CurrentOrder

    	def currency
    		Breeze::Commerce::Store.first.currency
    	end

    	# Replace normal Kaminari pagination rendering, which didn't work for me - Isaac
    	def paginate_products(products, options = {} )
        options[:class].to_s << ' pagination product_pagination'

    		content_tag :div, options do
	    		content_tag :ul do
	    			ul_content = ''
    			  unless products.current_page == 1
          		ul_content += content_tag :li do
            		link_to 'Prev', (products.current_page - 1).to_s
            	end
            end
            products.num_pages.times do |index|
            	page_num = index + 1
            	li_classes = 'active' if page_num == products.current_page
            	ul_content += content_tag :li, class: li_classes do
              	link_to page_num.to_s, page_num.to_s
            	end
          	end
    			  unless products.current_page == products.num_pages
          		ul_content += content_tag :li do
            		link_to 'Next', (products.current_page + 1).to_s
            	end
            end
            ul_content.html_safe
 		    	end
	    	end

    	end

    end
  end
end


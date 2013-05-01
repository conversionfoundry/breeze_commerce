require 'spec_helper'

describe "Personalised Message Flow", :js => true, :type => :request do

  before :each do
  	create(:country)
  	home_page = create(:home_page)
  	terms_page = create(:terms_page, parent_id: home_page.id)

  	store = Breeze::Commerce::Store.first
  	store.update_attribute(:home_page_id, home_page.id)
  	store.update_attribute(:terms_page_id, terms_page.id)
  	@product = create(:birthday_cake)
  	@product.variants << build(:personalised_birthday_cake)
  end

  context "Guest buying a product" do
	  it "allows customer to create a personalised message, and shows it in the cart and checkout" do

			visit @product.permalink

			page.should have_css('input#line_item_customer_message')
			page.should have_css('input.btn-add_to_cart')

			within "li.variant#variant_#{@product.variants.first.id}" do
				find(".name").should have_content "Personalised Birthday Cake"

	      fill_in 'Your message', with: "Happy Birthday to the World's Best Mum"
			  click_button 'Add to Cart'
			end

			visit @product.permalink

			within ".breeze-minicart .line_item" do
				find("p.customer_message").should have_content "Happy Birthday to the World's Best Mum"
			end

			@order = Breeze::Commerce::Order.last
			visit breeze.edit_order_path(@order)

			within ".line_item##{@order.line_items.first.id}" do
				find(".customer_message input.line_item-customer_message").value.should eq "Happy Birthday to the World's Best Mum"
			end

			click_link "Go to Checkout"

			within ".cart-container .line_item##{@order.line_items.first.id}" do
				find(".customer_message").should have_content "Happy Birthday to the World's Best Mum"
			end

	  end
	end
end

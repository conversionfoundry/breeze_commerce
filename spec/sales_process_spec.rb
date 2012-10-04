# -*- encoding : utf-8 -*-
require 'pry'

# The sales process, from customer arriving at store, to completing checkout

describe "customer", :type => :request, :js => true do

# def set_host (host)
#   host! host
#   Capybara.server_port = 31234
#   Capybara.app_host = "http://" + host
# end


  # Set up a dummy store.
  before :each do
    # host!  "localhost:3000"
    # Capybara.app_host = 'http://localhost:7787'

    # set_host "localhost:31234"

    set_up_dummy_store
  end

  # def host!(&block)
  #   before do
  #     Capybara.current_session.driver.reset!
  #     host! instance_eval(&block)
  #     @old_app_host, Capybara.app_host = Capybara.app_host, "http://#{host}"
  #     @old_default_host, Capybara.default_host = Capybara.default_host, "http://#{host}"
  #   end

  #   after do
  #     Capybara.current_session.driver.reset!
  #     Capybara.app_host = @old_app_host
  #     Capybara.default_host = @old_default_host
  #   end
  # end

  it "can make a successful purchase" do
    visit ('/')

    page.should have_content("Welcome to The Dummy Store")

    page.should have_css('div.breeze-minicart')
    find('div.breeze-minicart h3').should have_content("My Cart")
    find('div.breeze-minicart').should have_content('No items in your cart yet.')
    page.should have_css('div.breeze-content.breeze-product_list')
    find('div.breeze-content.breeze-product_list h3').should have_content("Dummies")
    page.should have_css('li.product')
    page.should have_content("Ventriloquist Dummy")

    click_link 'Ventriloquist Dummy'

    find('h1').should have_content("Ventriloquist Dummy")
    page.should have_content 'Scary but compelling'
    page.should have_css('table.variants tr.variant')
    find('table.variants tr.variant td.name').should have_content 'Freddie'
    page.should have_css ('table.variants tr.variant td.actions input.btn.btn-add_to_cart')
    find('table.variants tr.variant td.actions').should have_button('Add to Cart')


    # save_and_open_page
    click_button 'Test'
    # click_on 'Add to Cart'

    save_and_open_page

    page.should have_content('Ventriloquist Dummy')

    minicart = find('div.breeze-minicart')
    minicart.find('ul.line_items li.line_item').should have_content('1 × Freddie')

    # click_link 'Show Cart'

    # find('h1').should have_content('Shopping Cart')
  end

  # it 'can add a second product variant to the cart' do
  #   visit ('/')
  #   click_link 'Ventriloquist Dummy'
    
  #   minicart = find('div.breeze-minicart')

  #   click_button 'Add to Cart'
  #   click_button 'Add to Cart'
  #   minicart.find('ul.line_items li.line_item').should have_content('2 × Freddie')
  # end


  # go to the cart page
    # update quantity
    # remove a variant from the cart

  # go to checkout
    # fill out the form as guest

  # go to payment gateway
    # fill in correct credit card

  # return to store
    # see details of order
    # cart is empty

  # continue shopping

  # it "signs me in" do
  #   within("#session") do
  #     fill_in 'Login', :with => 'user@example.com'
  #     fill_in 'Password', :with => 'password'
  #   end
  #   click_link 'Sign in'
  # end

  private

  def set_up_dummy_store
    home_page = FactoryGirl.create(:home_page)
    dummy_store = FactoryGirl.create(:dummy_store)
    ventriloquist_dummy = FactoryGirl.create(:ventriloquist_dummy)
    dummy_store.products << ventriloquist_dummy
    freddie_dummy = FactoryGirl.create(:freddie_dummy)
    ventriloquist_dummy.variants << freddie_dummy
    my_cart = FactoryGirl.create(:my_cart)

    home_page.placements << Breeze::Content::Placement.new( :region => 'sidebar', :content => FactoryGirl.create(:welcome_snippet) )
    home_page.placements << Breeze::Content::Placement.new( :region => 'sidebar', :content => FactoryGirl.create(:store_welcome_snippet) )
    home_page.placements << Breeze::Content::Placement.new( :region => 'sidebar', :content => FactoryGirl.create(:dummies_list) )
    home_page.placements << Breeze::Content::Placement.new( :region => 'sidebar', :content => my_cart )
    # home_page.placements.first.should_receive(:position).and_return(1)

    ventriloquist_dummy.placements << Breeze::Content::Placement.new( :region => 'sidebar', :content => my_cart )

  end



end
# n.b. This spec requires a Pxpay account, with details set in the environment variables PXPAY_USER_ID and PXPAY_KEY

require 'spec_helper'

describe "Checkout", :js => true, :type => :request do

  before :each do
    create(:country)
    home_page = create(:home_page)
    terms_page = create(:terms_page, parent_id: home_page.id)

    Breeze.config.pxpay_user_id = ENV["PXPAY_USER_ID"]
    Breeze.config.pxpay_key = ENV["PXPAY_KEY"]

    store = Breeze::Commerce::Store.first
    store.update_attribute(:home_page_id, home_page.id)
    store.update_attribute(:terms_page_id, terms_page.id)
    @product = create(:birthday_cake)
    @product.variants << build(:personalised_birthday_cake)

    @order = create(:empty_order)
    @line_item = create(:line_item, order: @order)
  end

  context "Guest customer" do
    it "allows customer to complete checkout and make a payment" do

      visit breeze.checkout_order_path(@order)

      within "div.panel#sign-in" do
        fill_in 'Email', with: "guest@example.com"
        click_link 'Continue to next step'
        find(".checkout-summary #guest_email").should have_content "guest@example.com"
      end

      within "div.panel#shipping" do
        fill_in 'Name', with: "Guest Customer"
        fill_in 'Address', with: "10 Nonesuch Place"
        fill_in 'City', with: "Exampleburg"
        fill_in 'State, Province or Region', with: "Example"
        fill_in 'Postcode', with: "12345"
        fill_in 'Contact Phone Number', with: "64 3 1234567"
        click_link 'Continue to next step'
        find(".checkout-summary .summary").should have_content "Guest Customer"
      end

      within "div.panel#billing" do
        click_link 'Continue to next step'
      end

      within "div.panel#confirmation" do
        check 'read_terms'
        click_button 'Pay Now'
      end

      # Fill in the CC payment form
      find(:xpath, "//input[@name='CardNum']").set "4111111111111111"
      find(:xpath, "//select[@name='ExYr']").set "2017"
      find(:xpath, "//input[@name='NmeCard']").set "Example Name"
      find(:xpath, "//input[@name='Cvc2']").set "123"
      click_button 'submitImageButton'

      within ".order_confirmation" do
        find(".order_status h3").should have_content "Payment Confirmed"
      end

    end
  end
end

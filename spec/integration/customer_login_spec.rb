require 'spec_helper'

describe "Customer Login/Out", :js => true, :type => :request do

  before :each do
    home_page = create(:home_page)
    store = Breeze::Commerce::Store.first
    store.update_attribute(:home_page_id, home_page.id)
    @customer = create(:customer, email: "test@example.com")
    clf = create(:customer_login_form)
    home_page.placements << Breeze::Content::Placement.new( region: 'main', content: clf, view: "default" )
    visit "/"
  end

  it "renders the login form" do
    page.should have_css('.breeze-customer_login')
  end

  context "customer logs in correctly" do
    before :each do
      within ".breeze-customer_login" do
        fill_in 'Email', with: "test@example.com"
        fill_in 'Password', with: "logmein"
        click_button "Sign in"     
      end
    end

    it "allows customer to log in" do
      find(".breeze-customer_login").should have_content "Signed in as #{@customer.name}"
    end

    it "allows the customer to log out" do
      within ".breeze-customer_login" do
        click_link "Sign Out"     
      end
      save_and_open_page
      find(".breeze-customer_login").should_not have_content "Signed in as #{@customer.name}"
    end
  end

  it "doesn't allow incorrect login" do
    within ".breeze-customer_login" do
      fill_in 'Email', with: "test@example.com"
      fill_in 'Password', with: "incorrect_password"
      click_button "Sign in"     
    end
    find(".breeze-customer_login").should_not have_content "Signed in as #{@customer.name}"
  end

end

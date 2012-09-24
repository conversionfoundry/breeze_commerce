# Tests for an example store

describe "the dummy store", :type => :request do

  # Set up standard Breeze first-run elements.
  # TODO: Can we run the Breeze install generator from here instead?
  before :each do
    home_page = FactoryGirl.create(:home_page)
    welcome_snippet = FactoryGirl.create(:welcome_snippet)
    home_page.placements << Breeze::Content::Placement.new( :region => 'sidebar', :content => welcome_snippet )

    save_and_open_page

    # home_page.placements.first.should_receive(:position).and_return(1)
  end

  it "has a home page" do
    visit ('/')

    page.should have_content("Welcome to Breeze!")
  end






  # it "signs me in" do
  #   within("#session") do
  #     fill_in 'Login', :with => 'user@example.com'
  #     fill_in 'Password', :with => 'password'
  #   end
  #   click_link 'Sign in'
  # end

end
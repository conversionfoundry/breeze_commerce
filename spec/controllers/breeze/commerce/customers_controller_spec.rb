require 'spec_helper'


describe Breeze::Commerce::CustomersController do

  describe "authorization" do

  	before :each do
    	@actions = Breeze::Commerce::CustomersController.public_instance_methods(false).reject{ |action| ['rescue_action'].include?(action) }
  	end

    context "visitor (not logged in) accessing customer's profile" do
	    # it "redirects all actions" do
	    # 	@actions.each do |action|
		   #    get action, use_route: 'breeze_commerce'
		   #    response.should be_redirect
		   #  end
	    # end
		end

		context "logged-in customer accessing own profile" do
			before :each do
				sign_in FactoryGirl.create(:customer)
			end

			# it "shows the dashboard" do
			# 	get :index, use_route: 'breeze_commerce'
	  #     response.should be_success
	  #     response.should render_template("index")
			# end


			# it "shows the settings page" do
			# 	get :settings, use_route: 'breeze_commerce'
	  #     response.should be_success
	  #     response.should render_template("settings")
			# end
		end

    context "logged-incustomer accessing another customer's profile" do
			# before :each do
			# 	sign_in FactoryGirl.create(:merchant)
			# end
	  #   it "redirects all actions" do
	  #   	@actions.each do |action|
		 #      get action, use_route: 'breeze_commerce'
		 #      response.should be_redirect
		 #    end
	  #   end
		end


  end

end
require 'spec_helper'


describe Breeze::Commerce::CustomersController do

  describe "authorization" do

  	before :each do
    	@actions = Breeze::Commerce::CustomersController.public_instance_methods(false).reject{ |action| ['rescue_action'].include?(action) }
  	end

    context "customer accessing another customer's profile" do
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

		context "customer accessing own profile" do
			# before :each do
			# 	sign_in FactoryGirl.create(:merchant)
			# end

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
  end

end
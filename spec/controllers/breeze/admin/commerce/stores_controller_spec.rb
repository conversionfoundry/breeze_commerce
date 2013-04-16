require 'spec_helper'

describe Breeze::Admin::Commerce::StoresController do

  describe "authorization" do

    before :each do
      @actions = Breeze::Admin::Commerce::StoresController.public_instance_methods(false).reject{ |action| ['rescue_action'].include?(action) }
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end

    context "no user logged in" do
      it "redirects all actions" do
        @actions.each do |action|
          get action, use_route: 'breeze_commerce'
          response.should be_redirect
        end
      end
    end

    context "admin user logged in" do
      before :each do
        sign_in FactoryGirl.create(:admin)
      end

      it "shows the settings page" do
        @actions.each do |action|
          get action, use_route: 'breeze_commerce'
          response.should be_success
        end
      end
    end

    context "merchant user logged in" do
      before :each do
        sign_in FactoryGirl.create(:merchant)
      end

      it "shows the settings page" do
        get :edit, use_route: 'breeze_commerce'
        response.should be_success
      end
    end
  end

end
require 'spec_helper'

describe Breeze::Admin::Commerce::StoresController do

  before :each do
    request.env["HTTP_REFERER"] = "where_i_came_from"
  end

  describe "#edit" do
    context "no user logged in" do
      it "redirects all actions" do
        get :edit, use_route: 'breeze_commerce'
        response.should be_redirect
      end
    end
    context "admin user logged in" do
      it "can reach all actions" do
        sign_in FactoryGirl.create(:admin)
        get :edit, use_route: 'breeze_commerce'
        response.should be_success
      end
    end
    context "merchant user logged in" do
      it "shows the settings page" do
        sign_in FactoryGirl.create(:merchant)
        get :edit, use_route: 'breeze_commerce'
        response.should be_success
      end
    end
  end

end
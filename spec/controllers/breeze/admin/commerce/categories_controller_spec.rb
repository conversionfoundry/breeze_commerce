require 'spec_helper'

describe Breeze::Admin::Commerce::CategoriesController do

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    @admin = FactoryGirl.create(:admin)
    @admin.roles << :admin
    sign_in @admin # Using factory girl as an example
  end

	describe 'GET #index' do
		it "populates an array of categories" do
			category = create(:category)
			# controller.stub(:current_user){ double'User' }
			# Breeze::Commerce::Category.stub_chain(:where, :order_by, :paginate) { [category] }
    binding.pry
			get controller.index
      response.should be_success

			assigns(:categories).should eq [category]
		end
		it "renders the :index view"
	end
	
end
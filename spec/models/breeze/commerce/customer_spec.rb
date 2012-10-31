require 'spec_helper'
require "cancan/matchers"

describe Breeze::Commerce::Customer do
	it "has a valid factory" do
		create(:customer).should be_valid
	end
	it "is invalid without a first_name" do
		build(:customer, first_name: nil).should_not be_valid
	end
	it "is invalid without a last_name" do
		build(:customer, last_name: nil).should_not be_valid
	end
	it "is invalid with a duplicate email address" do
		create(:customer, email: "foo@example.com")
		build(:customer, email: "foo@example.com").should_not be_valid
	end
	it "returns a customer's full name as a string" do
		create(:customer, first_name: "John", last_name: "Doe").name.should eq "John Doe"
	end
	describe "scopes" do
		before :each do
			@smith = create(:customer, last_name: "Smith")
			@jones = create(:customer, last_name: "Jones")
			@johnson = create(:customer, last_name: "Johnson", archived: true)
			@dupond = create(:customer, last_name: "Dupond", archived: true)
		end			
		context "unarchived scope" do
			it "returns an array of unarchived customers" do
				Breeze::Commerce::Customer.unarchived.to_a.should eq [@smith, @jones]
				Breeze::Commerce::Customer.unarchived.should_not include @johnson
				Breeze::Commerce::Customer.unarchived.should_not include @dupond
			end
		end
		context "archived scope" do
			it "returns an array of archived customers" do
				Breeze::Commerce::Customer.archived.should eq [@johnson, @dupond]
				Breeze::Commerce::Customer.archived.should_not include @smith
				Breeze::Commerce::Customer.archived.should_not include @jones
			end
		end

		context "managing profile" do
			it "can manage own profile" do
	      customer = create(:customer)
        customer.should be_able_to(:manage, customer)
			end
			it "cannot manage another user's profile" do
	      customer1 = create(:customer)
	      customer2 = create(:customer)
        customer1.should be_able_to(:manage, customer2)
			end
		end
	end
end
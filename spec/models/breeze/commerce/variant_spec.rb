require 'spec_helper'

describe Breeze::Commerce::Variant do
	it "has a valid factory" do
		create(:variant).should be_valid
	end
	it "is invalid without a product_id" do
		build(:variant, product_id: nil).should_not be_valid
	end
	# it "is invalid without a last_name" do
	# 	build(:customer, last_name: nil).should_not be_valid
	# end
	# it "is invalid with a duplicate email address" do
	# 	create(:customer, email: "foo@example.com")
	# 	build(:customer, email: "foo@example.com").should_not be_valid
	# end
	# it "returns a customer's full name as a string" do
	# 	create(:customer, first_name: "John", last_name: "Doe").name.should eq "John Doe"
	# end
	describe "archive scopes" do
		before :each do
			@variant1 = create(:variant)
			@variant2 = create(:variant)
			@variant3 = create(:variant, archived: true)
			@variant4 = create(:variant, archived: true)
		end			
		context "unarchived scope" do
			it "returns an array of unarchived variants" do
				Breeze::Commerce::Variant.unarchived.to_a.should eq [@variant1, @variant2]
				Breeze::Commerce::Variant.unarchived.should_not include @variant3
				Breeze::Commerce::Variant.unarchived.should_not include @variant4
			end
		end
		context "archived scope" do
			it "returns an array of archived variants" do
				Breeze::Commerce::Variant.archived.should eq [@variant3, @variant4]
				Breeze::Commerce::Variant.archived.should_not include @variant1
				Breeze::Commerce::Variant.archived.should_not include @variant2
			end
		end
	end

	describe "available scope" do
		before :each do
			@variant1 = create(:variant)
			@variant2 = create(:variant)
			@variant3 = create(:variant, available: true)
			@variant4 = create(:variant, available: true)
		end			
		it "returns an array of available variants" do
			Breeze::Commerce::Variant.available.should eq [@variant3, @variant4]
			Breeze::Commerce::Variant.available.should_not include @variant1
			Breeze::Commerce::Variant.available.should_not include @variant2
		end
	end

	describe "with_option scope" do
		before :each do
			@option = create(:option)
			@variant1 = create(:variant)
			@variant2 = create(:variant)
			@variant3 = create(:variant)
			@variant1.options << @option
			@variant2.options << @option
		end			
		it "returns an array of variants" do
			Breeze::Commerce::Variant.with_option(@option).should eq [@variant1, @variant2]
			Breeze::Commerce::Variant.with_option(@option).should_not include @variant3
		end
	end

	it "returns an array of variants that share a given array of options" do
		@option1 = create(:option)
		@option2 = create(:option)
		@variant1 = create(:variant, name: 'variant1')
		@variant2 = create(:variant, name: 'variant2')
		@variant3 = create(:variant, name: 'variant3')
		@variant1.options << @option1
		@variant2.options << @option2
		@variant3.options << @option1
		@variant3.options << @option2
		binding.pry
		Breeze::Commerce::Variant.with_options([@option1, @option2]).to_a.should eq [@variant3]
		Breeze::Commerce::Variant.with_options([@option1, @option2]).should_not include @variant1
		Breeze::Commerce::Variant.with_options([@option1, @option2]).should_not include @variant2
	end

end
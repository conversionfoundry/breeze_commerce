require 'spec_helper'

describe Breeze::Commerce::Variant do
	it "has a valid factory" do
		create(:variant).should be_valid
	end
	it "is invalid without a product_id" do
		build(:variant, product_id: nil).should_not be_valid
	end
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

	describe "published scope" do
		before :each do
			@variant1 = create(:variant)
			@variant2 = create(:variant)
			@variant3 = create(:variant, published: true)
			@variant4 = create(:variant, published: true)
		end			
		it "returns an array of published variants" do
			Breeze::Commerce::Variant.published.should eq [@variant3, @variant4]
			Breeze::Commerce::Variant.published.should_not include @variant1
			Breeze::Commerce::Variant.published.should_not include @variant2
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

end
require 'spec_helper'

describe Breeze::Commerce::Variant do
	it "has a valid factory" do
		create(:variant).should be_valid
	end
	it "is invalid without a product_id" do
		build(:variant, product_id: nil).should_not be_valid
	end

	describe "sku_code" do
		context "missing SKU" do
			it "creates a SKU for a variant with no options" do
				@product = create(:product, name: 'Widget')
				@variant = create(:variant, product_id: @product.id, sku_code: nil)
				@variant.sku_code.should eq 'widget'
			end
			it "creates a SKU for a variant with options" do
				@option = create(:option, name: 'foo')
				@variant = create(:variant, sku_code: nil)
				@variant.options << @option
				binding.pry
				@variant.sku_code.should eq 'widget_foo'
			end
		end
		it "adds -2 to the end if given a SKU that already exists"
		it "increments final SKU digit until it finds one that doesn't exist"
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
			@variant1 = create(:unpublished_variant)
			@variant2 = create(:unpublished_variant)
			@variant3 = create(:variant)
			@variant4 = create(:variant)
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
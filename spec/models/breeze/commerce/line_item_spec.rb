require 'spec_helper'

describe Breeze::Commerce::LineItem do
	it "has a valid factory" do
		create(:line_item).should be_valid
	end

	describe "validation" do
		it "is invalid with no order" do
			build(:line_item, order: nil).should_not be_valid
		end
		it "is invalid with no variant" do
			build(:line_item, variant: nil).should_not be_valid
		end
		it "is invalid with no quantity" do
			build(:line_item, quantity: nil).should_not be_valid
		end
		it "is invalid with zero quantity" do
			build(:line_item, quantity: 0).should_not be_valid
		end
		it "is invalid with negative quantity" do
			build(:line_item, quantity: -100).should_not be_valid
		end
	end

	describe "data integrity" do
		before :each do
			@order = create(:order)
			@variant = create(:variant)
			@line_item = create(:line_item, variant: @variant, order: @order)
		end
		context "when it's first created" do
			it "has the same name as its variant" do
				@line_item.name.should eq @variant.name
			end
			it "has the same price as its variant" do
				@line_item.price.should eq @variant.display_price
			end
			it "has the same SKU as its variant" do
				@line_item.sku_code.should eq @variant.sku_code
			end
		end
		context "when the variant changes" do
			it "keeps the old name when the variant name changes" do
				old_variant_name = @variant.name
				@variant.update_attribute(:name, 'a different name for the variant now')
				@line_item.name.should_not eq @variant.name
				@line_item.name.should eq old_variant_name
			end
			it "keeps the old price when the variant price changes" do
				old_variant_price = @variant.sell_price
				@variant.update_attribute(:sell_price_cents, 50)
				@line_item.price.should_not eq @variant.sell_price
				@line_item.price.should eq old_variant_price
			end
			it "keeps the old SKU when the variant SKU changes" do
				old_variant_sku = @variant.sku_code
				@variant.update_attribute(:sku_code, 'a-different-sku')
				@line_item.sku_code.should_not eq @variant.sku_code
				@line_item.sku_code.should eq old_variant_sku
			end
		end
	end



end
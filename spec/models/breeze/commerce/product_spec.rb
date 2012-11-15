require 'spec_helper'

describe Breeze::Commerce::Product do

	# subject do 
	# 	create(:order, store: Breeze::Commerce::Store.first)
	# end


	it "has a valid factory" do
		create(:product).should be_valid
	end

	describe "show_in_navigation field" do
		it "can be shown in navigation" do 
			create(:product, show_in_navigation: true).show_in_navigation.should eq true
		end
		it "can be hidden from navigation" do
			create(:product, show_in_navigation: false).show_in_navigation.should eq false
		end
		it "is hidden from navigation by default" do
			create(:product).show_in_navigation.should eq false
		end
	end

	describe "teaser field" do
		it "can have a teaser" do
			create(:product, teaser: 'foo').teaser.should eq 'foo'
		end
	end

	describe "name alias" do		
		it "can refer to its title as its name" do
			create(:product, title: 'foo').name.should eq 'foo'
		end
		it "can set a name" do
			create(:product, name: 'bar').name.should eq 'bar'
		end
		it "can set a name and retrieve as title" do
			create(:product, name: 'baz').title.should eq 'baz'
		end
	end

	describe "validation" do
		it "is invalid when an associated variant is invalid" do
			@product = create(:product)
			@invalid_variant = build(:variant, name: nil)
			@product.variants << @invalid_variant
			@product.should_not be_valid
		end
	end

	describe "related products" do
		it "can find related products" do
			@product1 = create(:product)
			@product2 = create(:product)
			create(:product_relationship, parent_product: @product1, child_product: @product2)
			@product1.related_products.should include @product2
		end
	end

	describe "price methods" do
		before :each do
			@product = create(:product)
			create(:variant, sell_price: 0.01, product_id: @product.id)
			create(:variant, sell_price: 10.00, product_id: @product.id)
			create(:variant, sell_price: 10000.00, product_id: @product.id)
		end
		it "can report the minimum display price for its variants" do
			@product.display_price_min.should eq 0.01
		end
		it "can report the maximum display price for its variants" do
			@product.display_price_max.should eq 10000.00
		end
		it "can report a single display price" do
			@product.display_price.should eq 0.01
		end
	end

	describe "single_display_price? method"	do
		before :each do
			@product = create(:product)
		end
		context "when there are no variants" do
			it "reports that all variants have the same price" do
				@product.single_display_price?.should eq true
			end
		end
		context "when the variants have different prices" do
			it "reports that all variants have the same price" do
				create(:variant, sell_price: 1, product_id: @product.id)
				create(:variant, sell_price: 2, product_id: @product.id)
				@product.single_display_price?.should eq false
			end
		end
		context "when the variants all have the same price" do
			it "reports that all variants have the same price" do
				create(:variant, sell_price: 1, product_id: @product.id)
				create(:variant, sell_price: 1, product_id: @product.id)
				@product.single_display_price?.should eq true
			end
		end
	end

	describe "variant discount methods" do		
		before :each do
			@product = create(:product)
		end
		context "when it has no variants" do
			it "reports no discounted variants" do
				@product.any_variants_discounted?.should eq false
			end
			it "reports not all variants are discounted" do
				@product.all_variants_discounted?.should eq false
			end
		end
		context "when it has no discounted variants" do
			before :each do
				create(:variant, product_id: @product.id)
				create(:variant, product_id: @product.id)
			end
			it "reports no discounted variants" do
				@product.any_variants_discounted?.should eq false
			end
			it "reports not all variants are discounted" do
				@product.all_variants_discounted?.should eq false
			end
		end
		context "when it has discounted and non-discounted variants" do
			before :each do
				create(:variant, product_id: @product.id)
				create(:discounted_variant, product_id: @product.id)
			end
			it "reports it has discounted variants" do
				@product.any_variants_discounted?.should eq true
			end
			it "reports not all variants are discounted" do
				@product.all_variants_discounted?.should eq false
			end
		end
		context "when it has only discounted variants" do
			before :each do
				create(:discounted_variant, product_id: @product.id)
				create(:discounted_variant, product_id: @product.id)
			end
			it "reports it has discounted variants" do
				@product.any_variants_discounted?.should eq true
			end
			it "reports that all variants are discounted" do
				@product.all_variants_discounted?.should eq true
			end
		end
	end

	describe "last_update method" do
		context "if the last update was today" do
			it "shows just the time" do
				@product = create(:product, updated_at: Time.zone.now)
				@product.last_update.should match /\d{1,2}:\d{2} (A|P)M/
			end
		end
		context "if the last update was before today" do
			it "shows time and date" do
				@product = create(:product, updated_at: Time.zone.now - 2.days)
				@product.last_update.should include (Time.zone.now - 2.days).year.to_s
			end
		end
	end

	describe "number_of_sales" do
		before :each do
			@product = create :product
		end

	  context "when it has no variants" do
			it "has had no sales" do
				@product.number_of_sales.should eq 0
			end
	  end
		context "when its variants have had no sales" do
			it "has had no sales" do
				variant1 = create(:variant, product_id: @product.id)
				variant2 = create(:variant, product_id: @product.id)
				variant1.stub(:number_of_sales){0} 
				variant2.stub(:number_of_sales){0} 
				@product.number_of_sales.should eq 0
			end
		end
		context "when some variants have had sales" do
			it "counts the correct number of sales" do
				variant1 = create(:variant, product_id: @product.id)
				variant2 = create(:variant, product_id: @product.id)
				variant3 = create(:variant, product_id: @product.id)
				variant1.stub(:number_of_sales){0} 
				variant2.stub(:number_of_sales){1} 
				variant3.stub(:number_of_sales){3} 
				@product.stub_chain(:variants, :unarchived) {[variant1, variant2, variant3]}
				@product.number_of_sales.should eq 4
			end
		end
	end

	describe "has_tag_named?" do
		context "when it has no tags" do
			it "reports that it doesn't have a given tag" do
				@product = create :product
				@tag = create :tag
				@product.has_tag_named?(@tag.name).should eq false
			end
		end
		context "when it has a tag" do
			it "reports that it has the tag" do
				@product = create :product
				@tag = create :tag
				@product.tags << @tag
				@product.has_tag_named?(@tag.name).should eq true
			end
		end
	end

	describe "scopes" do
		describe "default scope" do
			it "returns an array in alphabetical order" do
				@producta = create(:product, name: 'Product A')
				@productb = create(:product, name: 'Product B')
				@productc = create(:product, name: 'Product C')
				@productd = create(:product, name: 'Product D')
				@producte = create(:product, name: 'Product E')
				Breeze::Commerce::Product.all.first.should eq @producta
				Breeze::Commerce::Product.all.last.should eq @producte
			end
		end
		describe "archived scope" do
			before :each do
				@product1 = create(:product)
				@product2 = create(:product)
				@product3 = create(:product, archived: true)
				@product4 = create(:product, archived: true)
			end			
			context "unarchived scope" do
				it "returns an array of unarchived products" do
					Breeze::Commerce::Product.unarchived.to_a.should eq [@product1, @product2]
					Breeze::Commerce::Product.unarchived.should_not include @product3
					Breeze::Commerce::Product.unarchived.should_not include @product4
				end
			end
			context "archived scope" do
				it "returns an array of archived products" do
					Breeze::Commerce::Product.archived.to_a.should eq [@product3, @product4]
					Breeze::Commerce::Product.archived.should_not include @product1
					Breeze::Commerce::Product.archived.should_not include @product2
				end
			end
		end
		describe "published scope" do
			before :each do
				@product1 = create(:product)
				@product2 = create(:product)
				@product3 = create(:product, published: true)
				@product4 = create(:product, published: true)
			end			
			context "unpublished scope" do
				it "returns an array of unpublished products" do
					Breeze::Commerce::Product.unpublished.to_a.should eq [@product1, @product2]
					Breeze::Commerce::Product.unpublished.should_not include @product3
					Breeze::Commerce::Product.unpublished.should_not include @product4
				end
			end
			context "published scope" do
				it "returns an array of published products" do
					Breeze::Commerce::Product.published.to_a.should eq [@product3, @product4]
					Breeze::Commerce::Product.published.should_not include @product1
					Breeze::Commerce::Product.published.should_not include @product2
				end
			end
		end
		describe "with_tag scope" do
			before :each do
				@tag1 = create(:tag)
				@tag2 = create(:tag)
				@product_with_tag1 = create(:product)
				@product_with_tag2 = create(:product)
				@product_with_tag1.tags << @tag1
				@product_with_tag2.tags << @tag2
				@product_notag = create(:product)
			end			
			context "with_tag scope" do
				it "returns an array of products with a given tag" do
					Breeze::Commerce::Product.with_tag(@tag1).to_a.should eq [@product_with_tag1]
					Breeze::Commerce::Product.with_tag(@tag1).should_not include @product_with_tag2
					Breeze::Commerce::Product.with_tag(@tag1).should_not include @product_with_no_tag
				end
			end
		end		
	end

end
require 'spec_helper'

describe Breeze::Commerce::Payment do
	subject { create(:payment) }

	describe "validation" do
		it { should be_valid }
		it "is invalid without a currency" do
			build(:payment, currency: nil).should_not be_valid
		end
		it "is invalid without a name" do
			build(:payment, name: nil).should_not be_valid
		end
		it "is invalid without an email" do
			build(:payment, email: nil).should_not be_valid
		end
	end

	it "returns a referenced order" do
		@order = create(:order)
		create(:payment, order: @order).order.should eq @order
	end

end